class MakeDefaultCompletedFalse < ActiveRecord::Migration
  def change
    change_column :shifts, :completed, :boolean, :default => false
  end
end
