include UserRatingMaths, SharedModelUpdates

class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]

  # POST /media/:media_id/rating
  def create
    @rating = Rating.new(user_id: current_user.id, media_id: params[:media_id], status_id: 0)
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

    new_score = rating_params[:score]
    old_score = @rating.score
    # Determine if score added (+1), score removed (-1) or no change (0)
    score_count_change = ((new_score.present? && old_score.blank?) ? 1 : (new_score.blank? && old_score.present?) ? -1 : 0)
    # Don't update media zscore sums if score nil -> nil, no change to score or no change to status
    do_update = score_count_change != 0 || new_score.to_i != old_score.to_i || rating_params[:status_id] != @rating.status_id

    if do_update # Skip transaction if no change
      success = ActiveRecord::Base.transaction do
        # Calculate and update user sum scores
        new_rating_sum, new_rating_sum_of_squares = update_user_sum_scores(@rating, new_score, old_score)
        count = @rating.user.scored_ratings + score_count_change
        # Calculate the new rating zscore and media zscore sum
        zscore = new_score.present? ? calc_z_score(new_score.to_i, new_rating_sum, new_rating_sum_of_squares, count) : 0
        @rating.update(score: new_score, status_id: rating_params[:status_id], zscore: zscore)
        @rating.save
      end

      update_rating_media_zscores(@rating) if do_update && success
      flash[success ? :info : :danger] = success ? 'Rating was successfully updated.' : 'Rating update failed.'
    end

    redirect_back fallback_location: root_path
  end

  # DELETE /media/:media_id/rating
  def destroy
    # Update user scores and destroy rating
    success = ActiveRecord::Base.transaction do
      # Update media if the rating has a score
      update_user_sum_scores(@rating, 0, @rating.score) if @rating.score.present?
      @rating.destroy
    end

    update_rating_media_zscores(@rating) if success
    flash[success ? :info : :danger] = success ? 'Rating was removed.' : 'Rating could not be removed.'
    redirect_back fallback_location: root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.includes(:user).find_by(user_id: current_user.id, media_id: params[:media_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:status_id, :score)
    end

end
