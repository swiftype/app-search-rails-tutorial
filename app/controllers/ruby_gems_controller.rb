class RubyGemsController < ApplicationController
  def index
    @rubygems = search_results
  end

  def show
    @rubygem = RubyGem.find(params[:id])
  end

  private

  def search_results
    if search_params[:q].present?
      # Worst Search Algorithm
      random_offset = [0, rand(RubyGem.count) - 10].max
      random_size = rand(100)

      RubyGem.offset(random_offset).limit(random_size)
    else
      []
    end
  end

  def search_params
    params.permit(:q)
  end
end
