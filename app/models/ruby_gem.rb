class RubyGem < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.from_json(json)
    parsed_json = JSON.parse(json)

    new_gem = self.new

    new_gem.name    = parsed_json['name']
    new_gem.authors = parsed_json['authors']
    new_gem.info    = parsed_json['info']

    new_gem.raw_json = parsed_json

    new_gem
  end

  def to_app_search_document
    {
      id: self.id,
      name: self.name,
      authors: self.authors,
      info: self.info,
    }
  end
end
