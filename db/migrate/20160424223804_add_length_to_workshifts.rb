class AddLengthToWorkshifts < ActiveRecord::Migration
  def change
    add_column :workshifts, :length, :decimal
  end
end
