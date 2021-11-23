class AddCheckedinGuides < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :checked_in_email, :string, array:true, default:[].to_yaml
  end
end
