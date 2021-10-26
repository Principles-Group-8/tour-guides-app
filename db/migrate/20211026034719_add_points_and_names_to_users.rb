class AddPointsAndNamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string, default: "First", null: false
    add_column :users, :last_name, :string, default: "Last", null: false
    add_column :users, :points, :integer, default: 0, null: false
  end
end
