class PreferencesController < ApplicationController

  def toggle_all
    # puts params
    if (defined? params[:pref_all] and params[:pref_all] == "on")
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
    render nothing: true
  end

  def toggle 
    u = User.find_by_id(params[:user_id])
    if (u != nil)
      u.update_attribute(:preference_open, false == u.preference_open)
      redirect_to admin_view_user_path
    end
  end
end