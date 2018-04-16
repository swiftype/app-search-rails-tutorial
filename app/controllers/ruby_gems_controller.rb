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
      #TODO handle pagination, errors
      search_client.search(search_params[:q])
    else
      []
    end
  end

  def search_params
    params.permit(:q)
  end

  def search_client
    @client ||= SearchClient.new
  end
end
