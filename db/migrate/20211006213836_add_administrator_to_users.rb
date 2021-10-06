class AddAdministratorToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :administrator, :boolean, default: false, null: false
  end
end
