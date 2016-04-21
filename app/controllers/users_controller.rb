class UsersController < ApplicationController

  def new
    if not admin_rights?
      redirect_to '/'
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to new_user_path
    end
  end
  
  def upload
    @users_uploaded = get_current_uploaded(params[:confirmed_ids])
    if (not params[:file].blank?)
      new_users = User.import(params[:file])
      @users_uploaded += new_users
    else
      flash[:danger] = "You must select a file to upload."
      redirect_to new_user_path
    end
  end
  
  def add_user
    @users_uploaded = get_current_uploaded(params[:confirmed_ids])
    new_user = User.new
    new_user.update_attributes(user_params)
    new_user.update_attribute(:password, User.random_pw)
    new_user.save
    @users_uploaded << new_user
    render "upload"
  end
  
  def get_all
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end
  
  def confirm_users
    params[:confirmed_ids].each do |id|
      User.send_confirmation(id)
    end
    flash[:success] =  "Sent confirmation email to users!" 
    redirect_to get_all_users_path
  end
  
  def upload_avatar
    @current_user.avatar = params[:user][:avatar]
    @current_user.save
    redirect_to user_profile_path
  end
  
  def show
    if (params[:id] == 'null') 
      redirect_to '/'
    end
    @user = User.find_by_id(params[:id])
  end
  
  def edit
    if current_user.id != params[:id].to_i
      redirect_to '/'
    end
    @user = User.find_by_id(params[:id])
  end

  def edit_email
    if (defined? params[:user] and defined? params[:user][:email])
      user = User.find_by_id(params[:id])
      user.email = params[:user][:email]
      user.save
      flash[:success] = "Your email has been updated."
    end
    redirect_to user_profile_path
  end

  def edit_password
    if (defined? params[:name] and defined? params[:password] and defined? params[:password_confirmation] and
      defined? User.find_by_id(params[:id]) and defined? params[:old_password])
      user = User.find_by_id(params[:id])
      if (params[:password] == params[:password_confirmation])
        if user.authenticate(params[:old_password])
          user.update_attribute(:password, params[:password])
          flash[:success] = "Your password has been updated."
          redirect_to user_profile_path
          return
        else
          flash[:danger] = "Invalid current password."
        end
      else
        flash[:danger] = "New passwords don't match."
      end
    end
    redirect_to edit_profile_path
  end
  
  $day_mapping = {
    0=> "Monday",
    1=> "Tuesday",
    2=> "Wednesday",
    3=> "Thursday",
    4=> "Friday",
    5=> "Saturday",
    6=> "Sunday"
  }
  
  def new_preferences
    if current_user.id != params[:id].to_i
      redirect_to '/'
    elsif current_user.has_saved_availability?
      flash[:warning] = "You have already set your preferences. Edit them here."
      redirect_to edit_preferences_path
    end
    
    @new = true
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = current_unit.get_metashifts_by_category
  end
  
  def edit_preferences
    if not current_user.has_saved_availability? 
      flash[:warning] = "You have not yet set your preferences. Please set them here."
      redirect_to new_preferences_path
    end
    @new = false
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = current_unit.get_metashifts_by_category
    @avail_dic = Avail.get_availability_mapping @user.avails
    @cat_dict = {}; 
    @meta_dict = {}; 
    @user.preferences.each do |preference|
      if preference.rating != 0
        @meta_dict[preference.metashift.id] = preference.rating
      end
      category = preference.metashift.category
      if !(@cat_dict.key?(category)) and preference.cat_rating != 0
          @cat_dict[category] = preference.cat_rating
      end
    end
  end
  
  def create_pref_and_avail
    save_preferences :create
    #Saving Avails
    avail = params["avail"]
    avail.each do |datetime, status|
      day, time = datetime.split(",")
      a = Avail.create(:hour => time.to_i, :day => day.to_i, :status => status)
      a.user = current_user
      a.save
    end
    current_user.notes = params["notes"]
    current_user.save
    flash[:success] = "Your preferences have been saved"
    redirect_to user_profile_path
  end
  
  def update_pref_and_avail
    save_preferences :update
    #Saving Avails
    avail = params["avail"]
    avail.each do |datetime, status|
      day, time = datetime.split(",")
      a = Avail.where(user: current_user).where(day: day.to_i).where(hour: time.to_i).first
      if a
        a.status = status
        a.save
      end
    end
    current_user.notes = params["notes"]
    current_user.save
    flash[:success] = "Your preferences have been edited successfully"
    redirect_to user_profile_path
  end
  
  def preference_access
    if not admin_rights?
      redirect_to '/'
    end
    @users = User.all
    if (defined? params[:change_preference_for_id] and params[:change_preference_for_id] == "all")
      User.all.each do | u |
        u.update_attribute(:preference_open, true)
      end
      redirect_to '/preference_access'
    end
    if (defined? params[:change_preference_for_id] and params[:change_preference_for_id] == "none")
      User.all.each do | u |
        u.update_attribute(:preference_open, false)
      end
      redirect_to '/preference_access'
    end
    user = User.find_by_id(params[:change_preference_for_id])
    if user == nil
      return
    end
    if (defined? user and defined? params[:change_preference_for_id])
      user = User.find_by_id(params[:change_preference_for_id])
      user.update_attribute(:preference_open, false == user.preference_open)
    end
    redirect_to '/preference_access'
  end
  
private

  def get_current_uploaded ids
    added = []
    if ids
      ids.each do |id|
        added << User.find(id)
      end
    end
    return added
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :permissions, :password, :password_confirmation, :avatar, :change_preference_for_id)
  end
  
  def save_preferences mode
    categories = params[:category]
    meta = params[:meta]
    meta.each do |id, rank|
      ms = Metashift.find_by_id(id.to_i)
      rank = rank.to_i
      if mode == :create
        pref = Preference.new
      elsif mode == :update
        pref = Preference.where(user: current_user).where(metashift: ms).first
      end
      if pref and ms
        pref.set_ratings categories[ms.category].to_i, rank
        pref.metashift = ms
        pref.user = current_user
        pref.save
      end
    end
  end
  
end