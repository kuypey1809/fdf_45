class AddImageToSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :image, :string
  end
end
