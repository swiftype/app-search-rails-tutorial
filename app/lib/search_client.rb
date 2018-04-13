class SearchClient
  attr_reader :client

  ENGINE_NAME = 'gem-hunt'

  def initialize
    @client = SwiftypeAppSearch::Client.new(
      account_host_key: Rails.application.credentials.swiftype[:account_host_key],
      api_key: Rails.application.credentials.swiftype[:api_key],
    )
  end

  def index(gems_to_index)
    documents = gems_to_index.map(&:to_app_search_document)

    #TODO handle errors somehow? Maybe wrap the response in a Response object?
    index_result = client.index_documents(ENGINE_NAME, documents)

    RubyGem.where(id: gems_to_index.map(&:id)).update_all(indexed_at: Time.now)

    index_result
  end
end
