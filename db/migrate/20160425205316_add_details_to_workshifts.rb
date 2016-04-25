class AddDetailsToWorkshifts < ActiveRecord::Migration
  def change
    add_column :workshifts, :details, :string
  end
end
