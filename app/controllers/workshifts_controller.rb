class WorkshiftsController < ApplicationController
  skip_before_filter :set_current_user
    
  # GET /workshifts/new
  def new
  end
  
  # GET /workshifts/assign
  def assign
    workshift = Workshift.find_by_id(288)
    @sorted_users_rankings = User.get_rankings_for workshift, current_unit
  end
  
  def show
  end
    
  # GET /workshifts
  # GET /workshifts.json
  def index
    @workshifts = Workshift.all
    @serializedWorkshifts = json_workshifts(@workshifts)
    @allUsers = User.all.to_json
  end
  
  def new_timeslots
    meta_id = params[:id]
    @metashift = (Metashift.find_by_id(meta_id))
    render 'new_timeslots'
  end
  
  def create_timeslots
    shift = params[:shift]
    @metashift = Metashift.find_by_id(shift[:metashift_id])
    Workshift.add_workshift(shift[:dayoftheweek], shift[:start_time], shift[:end_time], @metashift)
    redirect_to workshifts_path
  end
  
  # DELETE /workshifts/1
  # DELETE /workshifts/1.json
  def destroy
    @workshift = Workshift.find_by_id(params[:id])
    @workshift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url, notice: 'Workshift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def change_users
    params[:shift_ids].zip(params[:user_ids]).each do |shift_id, user_id|
      workshift = Workshift.find_by_id(shift_id)
      user = User.find_by_id(user_id)
      if user and workshift
        workshift.user = user
        workshift.save()
      else
        render :text => "Error saving work shifts", :status => 500, :content_type => 'text/html'
        return
      end
    end
    render :text => "Successfully saved work shifts", :status => 200, :content_type => 'text/html'
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def workshift_params
      params.require(:workshift).permit(:start_time, :end_time, :day, :metashift_id)
    end
    
    #Keys: shift, user, start_time, end_time, description
    def json_workshifts(instances)
      lst = []
      instances.each do |workshift|
        lst << workshift.full_json
      end
      lst
    end 
end