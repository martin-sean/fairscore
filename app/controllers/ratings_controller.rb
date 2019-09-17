class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]

  # POST /media/:media_id/rate
  def create
    @rating = Rating.new
    @rating.media_id = params[:id] # :id param is the media_id being rated
    @rating.status_id = 0
    @rating.user = current_user

    if @rating.save
      flash[:success] = 'Rating was added.'
    else
      flash[:danger] = 'Something went wrong while saving the rating.'
    end

    redirect_to params[:source]
  end

  # PATCH/PUT /media/:media_id/rate
  def update
    if @rating.update(rating_params)
      flash[:info] = 'Rating was successfully updated.'
      redirect_to params[:source]
    else
      render :edit
    end
  end

  # DELETE /media/:media_id/unrate
  def destroy
    @rating.destroy
    flash[:info] = 'Rating was removed.'
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
