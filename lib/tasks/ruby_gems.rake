namespace :ruby_gems do
  desc "load a json file of gem data into the database"
  task :populate, [:filename] => [:environment] do |t, args|
    docs = File.readlines(args.filename)

    Rails.logger.info "Populating gems from #{args.filename}"

    docs.each_with_index do |doc, index|
      Rails.logger.info "Importing line #{index} from #{args.filename}..."
      RubyGem.from_json(doc).save!
    end

    Rails.logger.info "Finished populating gems from #{args.filename}"
  end

  desc "do the initial indexing of a set of 100 ruby gems"
  task initial_index: [:environment] do |t|
    gems = RubyGem.where(indexed_at: nil).limit(100)

    if gems.none?
      Rails.logger.info "No unindexed gems found, skipping indexing."
    end

    Rails.logger.info "Attempting to index gems with IDs (#{gems.select(:id).map(&:id).join(', ')})"
    SearchClient.new.index(gems)
    #TODO handle the api response less optimistically
    Rails.logger.info "Done indexing, I hope it worked!"
  end
end