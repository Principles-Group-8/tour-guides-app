class AddAvailabilityFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    ["mon", "tues", "wed", "thur", "fri", "sat", "sun"].each do |day|
      ["_9", "_9:30", "_10", "_10:30", "_11", 
        "_11:30", "_12", "_12:30", "_1", "_1:30",
        "_2", "_2:30", "_3", "_3:30", "_4", "_4:30",
        "_5", "_5:30"].each do |time|
        add_column :users, "#{day}#{time}", :boolean, default: false, null: false
      end
    end
  end
end
