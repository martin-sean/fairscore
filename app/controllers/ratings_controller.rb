include UserMediaRatingMaths

class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]
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

    success = ActiveRecord::Base.transaction do
      new_score = rating_params[:score]
      old_score = @rating.score
      # Calculate and update user sum scores
      new_rating_sum, new_rating_sum_of_squares = update_user_sum_scores(@rating, new_score, old_score)
      # Determine the new scored rating count (counter cache hasn't updated yet)
      count = @rating.user.scored_ratings + ((new_score.blank? && old_score.present?) ? -1 : (new_score.present? && old_score.blank?) ? 1 : 0)
      # Calculate the new rating zscore and media zscore sum
      zscore = new_score.present? ? calc_z_score(new_score.to_i, new_rating_sum, new_rating_sum_of_squares, count) : 0
      @rating.media.zscore_sum += zscore - @rating.zscore.to_f
      @rating.media.save
      @rating.update(score: new_score, status_id: rating_params[:status_id], zscore: zscore)
      @rating.save
    end

    flash[success ? :info : :danger] = success ? 'Rating was successfully updated.' : 'Rating update failed.'
    redirect_back fallback_location: root_path
  end

  # DELETE /media/:media_id/rating
  def destroy
    # Update user scores and destroy rating
    success = ActiveRecord::Base.transaction do
      update_user_sum_scores(@rating, 0, @rating.score)
      # Update the current rating's media's zscore_sum
      @rating.media.zscore_sum -= @rating.zscore.to_f
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

    # Update the sums of scores of a rating's user during rating updates/media deletions
    def update_user_sum_scores(rating, new_score, old_score)
      # Calculate the rating sums for the user and the new zscore rating
      new_rating_sum = rating.user.rating_sum + new_score.to_i - old_score.to_i
      new_rating_sum_of_squares = rating.user.rating_sum_of_squares + new_score.to_i**2 - old_score.to_i**2
      rating.user.update(rating_sum: new_rating_sum, rating_sum_of_squares: new_rating_sum_of_squares)
      [new_rating_sum, new_rating_sum_of_squares]
    end

    # Update z-scores for all other user ratings
    def update_media_zscores
      @rating.user.ratings.each do |rating|
        # Skip rating if it was the modified rating or the rating has no score
        next if rating.id == @rating.id || rating.score.blank?

        new_zscore = calc_z_score(rating.score.to_i, rating.user.rating_sum, rating.user.rating_sum_of_squares, rating.user.reload.scored_ratings)
        rating.media.zscore_sum += new_zscore - rating.zscore
        rating.zscore = new_zscore
        rating.media.save
        rating.save
      end
    end
end
