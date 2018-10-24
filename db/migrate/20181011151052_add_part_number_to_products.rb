class AddPartNumberToProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :suggestions, :status, :integer
  end
end
