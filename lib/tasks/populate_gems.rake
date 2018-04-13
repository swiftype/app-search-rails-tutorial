desc "load a json file of gem data into the database"
task :populate_gems, [:filename] => [:environment] do |t, args|
  docs = File.readlines(args.filename)

  Rails.logger.info "Populating gems from #{args.filename}"

  docs.each_with_index do |doc, index|
    Rails.logger.info "Importing line #{index} from #{args.filename}..."
    RubyGem.from_json(doc).save!
  end

  Rails.logger.info "Finished populating gems from #{args.filename}"
end
