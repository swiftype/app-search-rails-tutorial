class RubyGemsController < ApplicationController

  PAGE_SIZE = 30

  def index
    if search_params[:q].present?
      @current_page = (search_params[:page] || 1).to_i
      @total_pages = (RubyGem.count / PAGE_SIZE.to_f).ceil

      page_offset = (@current_page - 1) * PAGE_SIZE

      @search_results = RubyGem.order(:created_at).limit(PAGE_SIZE).offset(page_offset)
    end
  end

  def show
    @rubygem = RubyGem.find(params[:id])
    @brian = "Brian Earwood"
  end

  private

  def search_params
    params.permit(:q, :page)
  end
end
