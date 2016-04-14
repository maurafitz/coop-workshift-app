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
      flash[:notice] = "No file specified."
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
      flash[:success] = "Email has been updated."
    end
    redirect_to user_profile_path
  end

  def edit_password
    if (defined? params[:name] and defined? params[:password] and defined? params[:password_confirmation] and defined? User.find_by_id(params[:id]))
      user = User.find_by_id(params[:id])
      if (params[:password] == params[:password_confirmation])
        user.update_attribute(:password, params[:password][0])
        flash[:success] = "Password has been updated."
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
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = @user.unit.metashifts.group_by {|metashift| 
        metashift.category}
    @new = true
  end
  
  def edit_preferences
    @new = false
    @user = current_user
    @day_mapping = $day_mapping
    @metashifts_by_category = @user.unit.metashifts.group_by {|metashift| 
        metashift.category}
    @avail_dic = {}
    @user.avails.each do |avail| 
      @avail_dic[avail.day.to_s + "," + avail.hour.to_s] = avail.status
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
    #Saving Avails
    avail = params["avail"]
    avail.each do |datetime, status|
      day, time = datetime.split(",")
      a = Avail.new
      a.user = current_user
      a.hour = time.to_i
      a.day = day.to_i
      a.status = status
      a.save
    end
    flash[:success] = "Your preferences have been saved"
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
    params.require(:user).permit(:first_name, :last_name, :email, :permissions, :password, :password_confirmation, :avatar)
  end
end