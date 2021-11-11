class FixTourTimeGuides < ActiveRecord::Migration[6.1]
  def change
    change_column :tours, :min_guides, :integer, default: 10
  end
end
