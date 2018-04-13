class AddIndexedAtToRubyGems < ActiveRecord::Migration[5.2]
  def change
    add_column :ruby_gems, :indexed_at, :datetime
  end
end
