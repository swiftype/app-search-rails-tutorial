# Loads Ruby Gems data from file

docs = File.readlines(File.expand_path('./data/rubygems.json'))

puts "\n-- seeding the database"

docs.each_with_index do |doc, i|
  RubyGem.from_json(doc).save!

  #Print a dot every 100 gems
  if (i % 100) == 0
    print '.'
    $stdout.flush
  end
end

print "done!\n"
