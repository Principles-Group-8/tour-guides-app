class AddEndTimeAndTourGuidesToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :end_time, :datetime
    add_column :tours, :min_guides, :datetime, default: 10, null: false
  end
end
