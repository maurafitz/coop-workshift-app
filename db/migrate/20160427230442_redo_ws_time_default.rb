class RedoWsTimeDefault < ActiveRecord::Migration
  def change
    change_column :workshifts, :start_time, :string, :default => '12pm'
    change_column :workshifts, :end_time, :string, :default => '3pm'
    change_column :workshifts, :length, :decimal, :default => 1.0
  end
end
