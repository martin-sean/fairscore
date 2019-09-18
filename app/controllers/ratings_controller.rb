include MediaRatingMaths

class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]

  # POST /media/:media_id/rate
  def create
    @rating = Rating.new
    @rating.media_id = params[:id] # :id param is the media_id being rated
    @rating.status_id = 0
    @rating.user_id = current_user.id

    success = @rating.save
    flash[success ? :info : :danger] = success ? 'Rating was added.' : 'Something went wrong while saving the rating.'
    redirect_to params[:source]
  end

  # PUT /media/:media_id/rate
  def update
    # Validate new score
    unless rating_params[:score].to_i.between?(Rating::MIN, Rating::MAX)
      flash[:danger] = 'Score was not valid'
      redirect_to params[:source]
    end

    # Enforce all updates occur or not at all
    success = ActiveRecord::Base.transaction do
      old_score = @rating.score.to_i # nil scores -> 0
      @rating.update(rating_params)
      update_user_scores(@rating, @rating.score.to_i, old_score)
    end

    flash[success ? :info : :danger] = success ? 'Rating was successfully updated.' : 'Rating update failed.'
    redirect_to params[:source]
  end

  # DELETE /media/:media_id/unrate
  def destroy
    # Ensure all updates occur or not at all
    success = ActiveRecord::Base.transaction do
      update_user_scores(@rating, 0, @rating.score.to_i)
      @rating.destroy
    end

    flash[success ? :info : :danger] = success ? 'Rating was removed.' : 'Rating could not be removed.'
    redirect_to params[:source]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:status_id, :score, :source)
    end

end
