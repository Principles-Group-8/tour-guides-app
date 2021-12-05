class AddAbsences < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :absences, :integer, default: 0
  end
end
