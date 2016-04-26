# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  before_filter :set_current_user
  protected # prevents method from being invoked by a route
  def set_current_user
    current_user
    authorize
  end
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    # we exploit the fact that find_by_id(nil) returns nil
    @current_user ||= User.find_by_id(session[:user_id])
    if not @current_user
      session[:user_id] = nil
    end
    return @current_user
  end
  helper_method :current_user

  def authorize
    redirect_to login_path and return unless @current_user
  end
  
  def admin_rights?
    self.current_user and self.current_user.is_ws_manager?
  end
  helper_method :admin_rights?
  
  def current_unit
    if current_user
      return current_user.unit
    elsif session[:unit]
      return Unit.find_by_id session[:unit]
    else
      return nil
    end
  end
  helper_method :current_unit
  
  def convert_to_id value
    value.gsub(/ /, "_")
  end 
  helper_method :convert_to_id
  
  def convert_to_time value
    i = value % 12
    if value == 12
      return "12pm"
    elsif value < 12
      return i.to_s + "am"
    else
      return i.to_s + "pm"
    end
  end
  helper_method :convert_to_time
end
