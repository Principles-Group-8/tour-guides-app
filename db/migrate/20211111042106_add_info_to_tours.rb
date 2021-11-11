class AddInfoToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :note, :string
    add_column :tours, :weekly, :boolean, null: false, default: false
    add_column :tours, :weeks, :integer
  end
end
