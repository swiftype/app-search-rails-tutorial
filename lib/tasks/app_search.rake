namespace :app_search do
  desc "index every Ruby Gem in batches of 100"
  task seed: [:environment] do |t|
    client = Search.client

    RubyGem.in_batches(of: 100) do |gems|
      Rails.logger.info "Indexing #{gems.count} gems..."

      documents = gems.map { |gem| gem.as_json(only: [:id, :name, :authors, :info, :downloads]) }

      client.index_documents(Search::ENGINE_NAME, documents)
    end
  end
end
