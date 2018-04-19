class SearchClient
  attr_reader :client

  ENGINE_NAME = 'gem-hunt'

  def initialize(client=build_client)
    @client = client
  end

  def build_client
    SwiftypeAppSearch::Client.new(
      account_host_key: Rails.application.credentials.swiftype[:account_host_key],
      api_key: Rails.application.credentials.swiftype[:api_key],
    )
  end

  def index(gems_to_index)
    raw_response = client.index_documents(ENGINE_NAME, gems_to_index.map(&:to_app_search_document))

    result = IndexResult.new(raw_response)

    RubyGem.where(id: result.successful_ids).update_all(indexed_at: Time.now)

    result
  end

  def search(query)
    #TODO handle errors somehow? Maybe wrap the response in a Response object?
    raw_response = client.search(ENGINE_NAME, query)

    #TODO Handle pagination, this only returns the first ten
    raw_response['results'].map{|i| parse_item(i) }
  end

  ResponseItem = Struct.new(:id, :name, :authors)

  def parse_item(raw_item)
    ResponseItem.new(
      raw_item['id']['raw'].to_i,
      raw_item['name']['raw'],
      raw_item['authors']['raw']
    )
  end
end
