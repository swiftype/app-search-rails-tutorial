class RubyGemsController < ApplicationController
  def index
    if search_params[:q].present?
      @search_response = search_client.search(search_params[:q], search_options)

      if @search_response.error?
        flash.now[:alert] = "We've run into a problem with our search provider. Please try again, or let us know!"
      end
    end
  end

  def show
    @rubygem = RubyGem.find(params[:id])
  end

  private

  def search_params
    params.permit(:q, :page)
  end

  def search_options
    page_param = search_params[:page] ? search_params[:page].to_i : 1

    {
      page: { current: page_param },
    }
  end

  def search_client
    @client ||= SearchClient.new
  end
end
