class AddCompensatedHoursToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compensated_hours, :integer
  end
end
