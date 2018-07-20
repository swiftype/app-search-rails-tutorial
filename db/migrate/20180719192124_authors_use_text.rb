class AuthorsUseText < ActiveRecord::Migration[5.2]
  def up
    change_column :ruby_gems, :authors, :text
  end

  def down
    change_column :ruby_gems, :authors, :string
  end
end
