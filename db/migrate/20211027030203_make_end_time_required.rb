class MakeEndTimeRequired < ActiveRecord::Migration[6.1]
  def change
    change_column :tours, :end_time, :datetime, null: false, default: Time.zone.now
  end
end
