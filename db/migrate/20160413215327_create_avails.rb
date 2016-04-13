class CreateAvails < ActiveRecord::Migration
  def change
    create_table :avails do |t|
      t.integer :time
      t.string :status
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
