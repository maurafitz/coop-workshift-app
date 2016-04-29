class AssignmentsController < ApplicationController
  # GET /assignments
  def new
    @metashift_rows = {}
    current_unit.metashifts.each do |metashift|
      @metashift_rows[metashift] = metashift.workshifts.group_by {|ws| ws.day}
    end
  end
  
  # POST /assignments/create
  def create
    assign_workshifts
    redirect_to user_profile_path(current_user.id)
  end
  
  def assign_workshifts
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
  end
  
  def sort_users
    puts params
    workshift = Workshift.find_by_id(params[:id])
    puts workshift
    puts current_unit
    @sorted_users_rankings = User.get_rankings_for workshift, current_unit
    puts @sorted_users_rankings
    @rows, @names, @mapping= [], [], {}
    @sorted_users_rankings.each do |user, ranking|
      @rows << {:name => "<a id='#{user.last_name}' href='#{admin_view_user_path(user.id)}'>#{user.full_name}</a>", :ranking => ranking}
      @names << user.full_name
      @mapping[user.full_name] = user.id
    end
    render json: {:rows => @rows, :names => @names, :mapping => @mapping}
  end
end