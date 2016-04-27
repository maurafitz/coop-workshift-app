class PreferencesController < ApplicationController

  def toggle_all
    # puts params
    if (params.has_key?(:pref_all) and params[:pref_all] == "on")
      puts "All On"
      User.all.each do | u |
        u.update_attribute(:preference_open, true)
      end
    else
      puts "All Off"
      User.all.each do | u |
        u.update_attribute(:preference_open, false)
      end
    end
    
  end

  def toggle 
    puts
    puts params
    u = User.find_by_id(params[:id])
    puts params.has_key?(:pref_all)
    puts params[:id] + " is now " + params.has_key?(:pref_all).to_s
    puts u
    if (u != nil)
      u.update_attribute(:preference_open, params.has_key?(:pref_all) ) 
    end
    render nothing: true
  end
end