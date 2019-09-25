include UserMediaRatingMaths, SharedModelUpdates

class MediaController < ApplicationController
  before_action :set_media, only: [:show, :edit, :update, :destroy]
  before_action :set_rating, only: [:show]
  before_action  :set_statuses, only: [:index, :show]

  # GET /media
  # GET /media.json
  def index
    @media = Media.includes(:ratings)
  end

  # GET /media/1
  # GET /media/1.json
  def show
  end

  # GET /media/new
  def new
    @media = Media.new
  end

  # GET /media/1/edit
  def edit
  end

  # POST /media
  # POST /media.json
  def create
    @media = Media.new(media_params)

    respond_to do |format|
      if @media.save
        format.html { redirect_to @media, notice: 'Media was successfully created.' }
        format.json { render :show, status: :created, location: @media }
      else
        format.html { render :new }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media/1
  # PATCH/PUT /media/1.json
  def update
    respond_to do |format|
      if @media.update(media_params)
        format.html { redirect_to @media, notice: 'Media was successfully updated.' }
        format.json { render :show, status: :ok, location: @media }
      else
        format.html { render :edit }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media/1
  # DELETE /media/1.json
  def destroy
    success = ActiveRecord::Base.transaction do
      # Remove rating scores from all users who have rated
      @media.ratings.each do |rating|
        # Update the user sum scores and media zscores for deleted media ratings
        update_user_sum_scores(rating, 0, rating.score.to_i)
        update_rating_media_zscores(rating)\\
      end
      @media.destroy
    end

    flash[success ? :info : :danger] = success ? 'Media was successfully destroyed.' : 'Media could not be destroyed.'
    respond_to do |format|
      format.html { redirect_to media_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media
      @media = Media.find(params[:id])
    end

    def set_rating
      @rating = Rating.find_by(media_id: params[:id], user_id: current_user)
    end

    def set_statuses
      @statuses = Status.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_params
      params.require(:media).permit(:title, :year, :info)
    end
end
