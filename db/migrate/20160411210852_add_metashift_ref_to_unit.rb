class AddMetashiftRefToUnit < ActiveRecord::Migration
  def change
    add_reference :metashifts, :unit, index: true, foreign_key: true
  end
end
