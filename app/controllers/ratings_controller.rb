include UserMediaRatingMaths

class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]
  after_action :request_update_media, only: [:update, :destroy]

  # POST /media/:media_id/rate
  def create
    @rating = Rating.new
    @rating.media_id = params[:media_id]
    @rating.status_id = 0
    @rating.user_id = current_user.id

    success = @rating.save
    flash[success ? :info : :danger] = success ? 'Rating was added.' : 'Something went wrong while saving the rating.'
    redirect_back fallback_location: root_path
  end

  # PUT /media/:media_id/rate
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
      current_user.scored_ratings += new_score && old_score.nil? ? 1 : new_score.blank? && old_score ? -1 : 0
      current_user.update_attribute(:scored_ratings, current_user.scored_ratings)
      @rating.update_attribute(:score, new_score)
      @rating.update_attribute(:status_id, rating_params[:status_id])
      update_user_scores(@rating, @rating.score.to_i, old_score.to_i) # nil scores -> 0
    end

    flash[success ? :info : :danger] = success ? 'Rating was successfully updated.' : 'Rating update failed.'
    redirect_back fallback_location: root_path
  end

  # DELETE /media/:media_id/unrate
  def destroy
    # Ensure all updates occur or not at all
    success = ActiveRecord::Base.transaction do
      current_user.scored_ratings -= 1
      current_user.update_attribute(:scored_ratings, current_user.scored_ratings)
      update_user_scores(@rating, 0, @rating.score.to_i)
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

    # Limit the number of requests to update a specific media to every 5 minutes
    def request_update_media
      # Possible N + 1, check for preload
      current_user.media.each do |media|
        # if Time.current - media.updated_at >= Media::TEST_FAST_UPDATE_RATE
          MediaUpdateJob.perform_later(media)
        # end

      end
      # Use Queues
      # if Time.current - @rating.media.updated_at >= Media::UPDATE_RATE
      #   MediaUpdateJob.perform_later(@rating.media.id)
      # end
    end

    # # TODO: Move to PORO and use Job/Queue's
    # def test(media)
    #   zscore_sum = nil
    #   count = 0 # Count the non-nil ratings
    #   media.ratings.each do |rating|
    #     next if rating.score.nil? # Skip nil ratings
    #     zscore_sum = 0 if zscore_sum.nil? # Set
    #     user = rating.user
    #     zscore_sum += calc_z_score(rating.score, user.rating_sum, user.rating_sum_of_squares, user.scored_ratings)
    #     count += 1
    #   end
    #   media.update_attribute(:zscore, zscore_sum.present? ? zscore_sum.fdiv(count) : nil)
    # end

end
