include UserMediaRatingMaths

class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]
  before_action :set_old_zscore, only: :update
  after_action :update_media_zscores, only: [:update, :destroy]

  # POST /media/:media_id/rating
  def create
    @rating = Rating.new
    @rating.media_id = params[:media_id]
    @rating.status_id = 0
    @rating.user_id = current_user.id
    success = @rating.save
    flash[success ? :info : :danger] = success ? 'Rating was added.' : 'Something went wrong while saving the rating.'
    redirect_back fallback_location: root_path
  end

  # PUT /media/:media_id/rating
  def update
    # Validate new score
    unless rating_params[:score].to_i.between?(Rating::MIN, Rating::MAX)
      flash[:danger] = 'Score was not valid'
      redirect_back fallback_location: root_path
    end
    # Enforce all updates occur or not at all
    success = ActiveRecord::Base.transaction do
      new_score = rating_params[:score]
      old_score = @rating.score
      # Determine the count of scored ratings depending on the new rating (Scored_ratings cache hasn't been updated with the new rating yet)
      count = @rating.user.scored_ratings + ((new_score.blank? && !old_score.nil?) ? -1 : (!new_score.blank? && old_score.nil?) ? 1 : 0)
      @rating.update(score: new_score, status_id: rating_params[:status_id])
      update_dependent_scores(@rating, new_score, old_score, count)
      @rating.save
    end

    flash[success ? :info : :danger] = success ? 'Rating was successfully updated.' : 'Rating update failed.'
    redirect_back fallback_location: root_path
  end

  # DELETE /media/:media_id/rating
  def destroy
    # Update user scores and destroy rating
    success = ActiveRecord::Base.transaction do
      @rating.media.zscore_sum -= @rating.zscore.to_f unless @rating.zscore.nil?
      update_dependent_scores(@rating, 0, @rating.score, @rating.user.scored_ratings - 1)
      @rating.media.save
      @rating.destroy
    end
    flash[success ? :info : :danger] = success ? 'Rating was removed.' : 'Rating could not be removed.'
    redirect_back fallback_location: root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find_by(user_id: current_user.id, media_id: params[:media_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:status_id, :score)
    end

    # Remember the old zscore after an :update to recalculate the other media zscore_sums
    def set_old_zscore
      @old_zscore = @rating.zscore
    end

    # Update the sums of scores of a rating's user during rating updates/media deletions
    def update_dependent_scores(rating, new_score, old_score, count)
      new_rating_sum = rating.user.rating_sum + new_score.to_i - old_score.to_i
      new_rating_sum_of_squares = rating.user.rating_sum_of_squares + new_score.to_i**2 - old_score.to_i**2
      # Only calculate zscore if the new rating has a score
      zscore = new_score.blank? ? nil : calc_z_score(new_score.to_i, new_rating_sum, new_rating_sum_of_squares, count)
      rating.user.update_attribute(:rating_sum, new_rating_sum)
      rating.user.update_attribute(:rating_sum_of_squares, new_rating_sum_of_squares)
      rating.update(zscore: zscore)
    end

    # Update z-scores for all user ratings
    def update_media_zscores
      @rating.user.ratings.each do |rating|
        next if rating.zscore.nil? && rating.id != @rating.id # Skip nil zscores only if not current @rating

        new_zscore = calc_z_score(rating.score.to_i, rating.user.rating_sum, rating.user.rating_sum_of_squares, rating.user.reload.scored_ratings)
        rating.media.zscore_sum += new_zscore
        # Use old zscore if recent rating and old zscore is not nil
        rating.media.zscore_sum -= !rating.zscore.nil? ? (rating.id == @rating.id ? (!@old_zscore.nil? ? @old_zscore : 0) : rating.zscore.to_f) : 0
        rating.zscore = new_zscore
        rating.media.save
        rating.save
      end
    end
end
