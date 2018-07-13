class RubyGemsController < ApplicationController

  PAGE_SIZE = 30

  def index
    if search_params[:q].present?
      @current_page = (search_params[:page] || 1).to_i

      search_client = Search.client
      search_options = {
        search_fields: {
          name: { weight: 2.0 },
          info: {},
          authors: {},
        },
        page: {
          current: @current_page,
          size: PAGE_SIZE,
        },
      }

      if search_params[:popular].present?
        search_options[:filters] = {
          downloads: { from: 1_000_000 },
        }
      end

      search_response = search_client.search(Search::ENGINE_NAME, search_params[:q], search_options)
      @total_pages = search_response['meta']['page']['total_pages']
      result_ids = search_response['results'].map { |rg| rg['id']['raw'].to_i }

      @search_results = RubyGem.where(id: result_ids).sort_by { |rg| result_ids.index(rg.id) }
    end
  end

  def show
    @rubygem = RubyGem.find(params[:id])
  end

  private

  def search_params
    params.permit(:q, :page, :popular)
  end
end
