class AssignmentsController < ApplicationController
  # GET /assignments
  def new
    @metashift_rows = current_unit.get_metashift_workshifts
    
  end
  
  # POST /assignments/create
  def create
    workshifts = params[:workshifts]
    workshifts.each do |ws_id, u_id|
      ws = Workshift.find_by_id(ws_id)
      user = User.find_by_id(u_id)
      if user 
        ws.user = user
      else
        ws.user = nil
      end
      ws.save
    end
    redirect_to user_profile_path(current_user.id)
  end
  
  def sort_users
    workshift = Workshift.find_by_id(params[:id])
    @sorted_users_rankings = User.get_rankings_for workshift
    @rows, @names, @mapping= [], [], {}
    @sorted_users_rankings.each do |user, ranking|
      @rows << {:name => "<a id='#{user.last_name}' href='#{admin_view_user_path(user.id)}'>#{user.full_name}</a>", :ranking => ranking}
      @names << user.full_name
      @mapping[user.full_name] = user.id
    end
    render json: {:rows => @rows, :names => @names, :mapping => @mapping}
  end
end