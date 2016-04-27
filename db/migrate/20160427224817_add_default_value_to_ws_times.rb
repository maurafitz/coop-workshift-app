class AddDefaultValueToWsTimes < ActiveRecord::Migration
  def change
    change_column_default :workshifts, :start_time, :default => '12pm'
    change_column_default :workshifts, :end_time, :default => '3pm'
    change_column_default :workshifts, :length, :default => 1.0
  end
end
