class AddWorkshiftToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :workshift, index: true, foreign_key: true
  end
end
