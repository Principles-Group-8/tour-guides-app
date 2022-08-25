class AddCheckedinGuides < ActiveRecord::Migration[6.1]
  def change
    if Rails.env.production?
      add_column :tours, :checked_in_email, :string, array:true, default:[].to_yaml
    else
      add_column :tours, :checked_in_email, :string, array:true, default:[].to_yaml
    end
  end
end
