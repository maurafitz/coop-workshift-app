class ChangePrefopenDefault < ActiveRecord::Migration
  def change
    change_column :units, :preference_form_open, :boolean, :default => true
  end
end
