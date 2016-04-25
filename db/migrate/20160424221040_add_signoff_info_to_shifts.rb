class AddSignoffInfoToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :signoff_by, index: true, foreign_key: true
    add_column :shifts, :signoff_date, :datetime
  end
end
