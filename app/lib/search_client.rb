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

  def search(query, raw_options={})
    options = default_search_options.deep_merge(raw_options)

    begin
      SearchResult.new(client.search(ENGINE_NAME, query, options))

    rescue SwiftypeAppSearch::ClientException => e
      Rails.logger.error "SearchClient API client error: #{e.inspect}"

      SearchResult.new({}, e)
    end
  end

  private

  def default_search_options
    {
      search_fields: {
        name: { weight: 2.0 },
      },
      page: { size: 30 },
    }
  end
end
