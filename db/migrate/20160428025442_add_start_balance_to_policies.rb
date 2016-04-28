class AddStartBalanceToPolicies < ActiveRecord::Migration
  def up
    add_column :policies, :starting_hour_balance, :float, default: 5.0
  end

  def down
    remove_column :policies, :starting_hour_balance
  end
end
