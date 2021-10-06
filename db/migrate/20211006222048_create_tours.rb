class CreateTours < ActiveRecord::Migration[6.1]
  def change
    create_table :tours do |t|
      t.column :time, :datetime, null: false
      t.timestamps
    end

    create_join_table :users, :tours
  end
end
