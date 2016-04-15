class UsersController < ApplicationController

  def new
    if not @current_user.is_ws_manager?
      redirect_to '/'
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end
  
  def upload
    @users_uploaded = get_current_uploaded(params[:confirmed_ids])
    if (not params[:file].blank?)
      new_users = User.import(params[:file])
      @users_uploaded += new_users
    else
      flash[:danger] = "You must select a file to upload."
      redirect_to '/signup'
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
    if (defined? params[:name] and defined? params[:password] and defined? params[:password_confirmation] and defined? User.find_by_id(params[:id]))
      user = User.find_by_id(params[:id])
      if (params[:password] == params[:password_confirmation])
        user.update_attribute(:password, params[:password][0])
        flash[:success] = "Your password has been updated."
      else
        flash[:danger] = "Passwords did not match."
      end
    end
    redirect_to user_profile_path
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
    elsif current_user.avails.length != 0
      flash[:warning] = "You have already set your preferences. Edit them here."
      redirect_to edit_preferences_path
    end
    
    @new = true
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = @user.unit.metashifts.group_by {|metashift| 
        metashift.category}
  end
  
  def edit_preferences
    if current_user.avails.length == 0
      flash[:warning] = "You have not yet set your preferences. Please set them here."
      redirect_to new_preferences_path
    end
    @new = false
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = @user.unit.metashifts.group_by {|metashift| 
        metashift.category}
    @avail_dic = {}
    @user.avails.each do |avail| 
      @avail_dic[avail.day.to_s + "," + avail.hour.to_s] = avail.status
    end
    @cat_dict = {}; 
    @meta_dict = {}; 
    @user.preferences.each do |pref|
      @meta_dict[pref.metashift.id] = pref.rating
      cat = pref.metashift.category
      if !(@cat_dict.key?(cat))
        @cat_dict[cat] = pref.cat_rating
      end
    end
  end
  
  def set_pref_and_avail
    #Saving Preferences
    categories = params["category"]
    meta = params["meta"]
    meta.each do |id, rank|
      ms = Metashift.find_by_id(id.to_i)
      rank = rank.to_i
      pref = Preference.new
      if pref and ms
        cat = categories[ms.category].to_i
        if cat != 0
          pref.cat_rating = cat
        else
          pref.cat_rating = 3
        end
        if rank == 0
          rank = pref.cat_rating
        end
        pref.rating = rank
        pref.metashift = ms
        pref.user = current_user
        pref.save
      end
    end
    #Saving Avails
    avail = params["avail"]
    avail.each do |datetime, status|
      day, time = datetime.split(",")
      a = Avail.new
      if a
        a.user = current_user
        a.hour = time.to_i
        a.day = day.to_i
        a.status = status
        a.save
      end
    end
    current_user.notes = params["notes"]
    current_user.save
    flash[:success] = "Your preferences have been saved"
    redirect_to user_profile_path
  end
  
  def preference_access
    if not @current_user.is_ws_manager?
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
  
  def edit_pref_and_avail
    categories = params["category"]
    meta = params["meta"]
    meta.each do |id, rank|
      ms = Metashift.find_by_id(id.to_i)
      rank = rank.to_i
      pref = Preference.where(user: current_user).where(metashift: ms).first
      if pref and ms
        cat = categories[ms.category].to_i
        if cat != 0
          pref.cat_rating = cat
        else
          pref.cat_rating = 3
        end
        if rank == 0
          rank = pref.cat_rating
        end
        pref.rating = rank
        pref.metashift = ms
        pref.user = current_user
        pref.save
      end
    end
    #Saving Avails
    avail = params["avail"]
    avail.each do |datetime, status|
      day, time = datetime.split(",")
      a = Avail.where(user:current_user).where(day: day.to_i).where(hour: time.to_i).first
      if a
        a.user = current_user
        a.hour = time.to_i
        a.day = day.to_i
        a.status = status
        a.save
      end
    end
    current_user.notes = params["notes"]
    current_user.save
    flash[:success] = "Your preferences have been edited successfully"
    redirect_to user_profile_path
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
end