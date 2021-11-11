class FixTourTimeGuides < ActiveRecord::Migration[6.1]
  def change
    remove_column :tours, :min_guides
    add_column :tours, :min_guides, :integer, default: 10
  end
end
