class MakeLengthAndBalanceFloats < ActiveRecord::Migration
  def change
    change_column :workshifts, :length, :float, :default => 1.0
    change_column :users, :hour_balance, :float, :default => 0.0
    change_column :users, :fine_balance, :float, :default => 0.0
  end
end
