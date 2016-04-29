class AddPrefopenToUnit < ActiveRecord::Migration
  def change
    add_column :units, :preference_form_open, :boolean
  end
end
