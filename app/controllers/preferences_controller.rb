class PreferencesController < ApplicationController

  def toggle_all
    # puts params
    if (params.has_key?(:pref_all) and params[:pref_all] == "on")
      User.all.each do | u |
        u.update_attribute(:preference_open, true)
      end
    else
      User.all.each do | u |
        u.update_attribute(:preference_open, false)
      end
    end
    
  end

  def toggle 
    u = User.find_by_id(params[:id])
    if (u != nil)
      u.update_attribute(:preference_open, params.has_key?(:pref_all) ) 
    end
    render nothing: true
  end
end