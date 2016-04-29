class MakeFineAmountDefaultZero < ActiveRecord::Migration
  
  def change
    change_column :policies, :fine_amount, :integer, default: 0
  end
  
  
end
