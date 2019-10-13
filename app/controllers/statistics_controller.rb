class StatisticsController < ApplicationController
  before_action :set_ratings
  before_action :set_users
  before_action :set_graph_data

  def index
  end

  private

    def set_ratings
      @ratings = Rating.all
      @media = @ratings.collect(&:media_id).uniq
    end

    def set_users
      @users = User.all
    end

    def set_graph_data
      counts = @ratings.collect(&:score)
      @graph_data = Hash.new(0)
      (0..10).each {|i| @graph_data[i] = 0 }
      counts.each {|i| @graph_data[i] += 1 }
      @graph_data.delete nil
      @graph_data
    end
end
