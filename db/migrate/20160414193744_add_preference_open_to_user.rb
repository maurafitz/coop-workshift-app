class AddPreferenceOpenToUser < ActiveRecord::Migration
  def change
    add_column :users, :preference_open, :boolean, default: :true
  end
end
