class SearchResult
  attr_reader :raw_response, :exception, :current_page, :page_size, :total_pages, :total_results, :results

  ResponseItem = Struct.new(:id, :name, :authors)

  def initialize(raw_response, exception=nil)
    @raw_response = raw_response
    @exception = exception

    unless raw_response.empty?
      @current_page = raw_response['meta']['page']['current']
      @page_size = raw_response['meta']['page']['size']
      @total_pages = raw_response['meta']['page']['total_pages']
      @total_results = raw_response['meta']['page']['total_results']

      @results = raw_response['results'].map{|i| parse_item(i) }
    end
  end

  def parse_item(raw_item)
    ResponseItem.new(
      raw_item['id']['raw'].to_i,
      raw_item['name']['raw'],
      raw_item['authors']['raw']
    )
  end

  def error?
    !!exception
  end
end
