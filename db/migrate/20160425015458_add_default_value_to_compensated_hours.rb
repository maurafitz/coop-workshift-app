class AddDefaultValueToCompensatedHours < ActiveRecord::Migration
  def change
    change_column :users, :compensated_hours, :integer, :default => 0
  end
end
