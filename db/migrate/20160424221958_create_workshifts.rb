class CreateWorkshifts < ActiveRecord::Migration
  def change
    create_table :workshifts do |t|
      t.belongs_to :metashift, index: true, foreign_key: true
      t.string :start_time
      t.string :end_time
      t.string :day
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
