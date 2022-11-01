class AddIsValidToGenres < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :is_valid, :boolean
  end
end
