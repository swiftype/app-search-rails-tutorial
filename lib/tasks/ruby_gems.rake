namespace :app_search do
  desc "index every Ruby Gem in batches of 100"
  task seed: [:environment] do |t|
    if RubyGem.none?
      Rails.logger.info "No gems found, skipping indexing."
    else
      RubyGem.in_batches(of: 100) do |gems|
        Rails.logger.info "Attempting to index gems with IDs (#{gems.select(:id).map(&:id).join(', ')})"
      end
      result = SearchClient.new.index(gems)

      Rails.logger.info "Indexing successful for gems with IDs: (#{result.successful_ids.join(', ')})"

      if result.errored_documents.any?
        errored_gems = result.errored_documents.map {|d| [d.id, d.errors] }.to_h
        Rails.logger.info "Indexing failed for some gems (#{errored_gems.inspect})"
      end
    end
  end
end
