class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.references :user, index: true, foreign_key: true
      t.references :metashift, index: true, foreign_key: true
      t.integer :rating

      t.timestamps null: false
    end
  end
end
