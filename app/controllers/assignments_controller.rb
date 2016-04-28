class AssignmentsController < ApplicationController
  # GET /assignments/new
  def new
    @metashift_rows = {}
    current_unit.metashifts.each do |metashift|
      @metashift_rows[metashift] = metashift.workshifts.group_by {|ws| ws.day}
    end
  end
  
  # GET /assignments/edit
  def edit
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
  
  # POST /assignments/update
  def update
    assign_workshifts
    redirect_to edit_assignments_path
    # redirect_to user_profile_path(current_user.id)
  end
  
  def assign_workshifts
    workshifts = params[:workshifts]
    workshifts.each do |id, full_name|
      ws = Workshift.find_by_id(id)
      if full_name
        user = User.find_by_full_name(full_name).first
        if user
          ws.user = user
        end
      else
        ws.user = nil
      end
      ws.save
    end
  end
  
  def sort_users
    workshift = Workshift.find_by_id(params[:id])
    @sorted_users_rankings = User.get_rankings_for workshift, current_unit
    @rows, @names = [], []
    @sorted_users_rankings.each do |user, ranking|
      @rows << {:name => "<a id='#{user.last_name}' href='#{admin_view_user_path(user.id)}'>#{user.full_name}</a>", :ranking => ranking}
      @names << user.full_name
    end
    render json: {:rows => @rows, :names => @names}
  end
end