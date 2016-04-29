class PreferencesController < ApplicationController
  def toggle_all
    if (params.has_key?(:pref_all) and params[:pref_all] == "on")
      current_unit.update_attribute(:preference_form_open, true)
      User.where(unit: current_unit).each do | u |
        u.update_attribute(:preference_open, true)
      end
    else 
      current_unit.update_attribute(:preference_form_open, false)
      User.where(unit: current_unit).each do | u |
        u.update_attribute(:preference_open, false)
      end
    end
    render nothing: true
  end
  def toggle 
    u = User.find_by_id(params[:id])
    if (u != nil)
      u.update_attribute(:preference_open, params.has_key?(:pref_all) ) 
    end
    render nothing: true
  end
end