class RubyGemsController < ApplicationController
  def index
  end

  def show
    @rubygem = RubyGem.find(params[:id])
  end

  private

  def search_params
    params.permit(:q)
  end
end
