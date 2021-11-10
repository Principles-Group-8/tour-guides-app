class LocationAddition < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :location, :string, default: "HOG", null: false
  end
end
