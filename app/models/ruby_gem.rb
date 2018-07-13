class RubyGem < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.from_json(json)
    parsed_json = JSON.parse(json)

    new_gem = self.new

    new_gem.name      = parsed_json['name']
    new_gem.authors   = parsed_json['authors']
    new_gem.info      = parsed_json['info']
    new_gem.downloads = parsed_json['downloads']

    new_gem
  end
end
