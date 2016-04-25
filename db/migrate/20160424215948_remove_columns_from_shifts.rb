class RemoveColumnsFromShifts < ActiveRecord::Migration
  def change
    remove_column :shifts, :start_time, :datetime
    remove_column :shifts, :end_time, :datetime
    remove_reference :shifts, :metashift, index: true
  end
end
