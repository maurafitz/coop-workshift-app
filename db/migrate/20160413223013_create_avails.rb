class CreateAvails < ActiveRecord::Migration
  def change
    create_table :avails do |t|
      t.integer :day
      t.integer :hour
      t.belongs_to :user, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
