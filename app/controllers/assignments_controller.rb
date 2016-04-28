class AssignmentsController < ApplicationController
  # GET /assignments/new
  def new
    @metashift_rows = {}
    current_unit.metashifts.each do |metashift|
      @metashift_rows[metashift] = metashift.workshifts.group_by {|ws| ws.day}
    end
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def sort_users
    workshift = Workshift.find_by_id(params[:id])
    @sorted_users_rankings = User.get_rankings_for workshift, current_unit
    @rows = []
    @sorted_users_rankings.each do |user, ranking|
      @rows << {:name => "<a href='#{admin_view_user_path(user.id)}'>#{user.full_name}</a>", :ranking => ranking}
    end
    render json: {:rows => @rows}
  end
end