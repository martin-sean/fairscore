class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]

  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new
    @rating.media_id = params[:id]
    @rating.status_id = 0
    @rating.user = current_user

    unless @rating.save
      flash[:danger] = 'Something went wrong while saving the rating.'
    end

    redirect_to media_path
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    # TODO: id is currently Media id, not ratings id. Sort it out.

    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @media, flash[:info] = 'Rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @media }
      else
        format.html { render :edit }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to media_url, flash[:info] = 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:media_id, :status_id, :score)
    end

end
