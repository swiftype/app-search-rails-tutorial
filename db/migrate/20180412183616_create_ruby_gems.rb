class CreateRubyGems < ActiveRecord::Migration[5.2]
  def change
    create_table :ruby_gems do |t|
      t.string :name
      t.string :authors
      t.text :info

      t.json :raw_json

      t.timestamps
    end
  end
end
