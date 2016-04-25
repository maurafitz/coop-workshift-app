class SignoffsController < ApplicationController
    skip_before_filter :set_current_user
    def new
        if current_unit.nil?
            flash["warning"] = "You have not set your unit yet. Please do so now"
            redirect_to get_unit_path
        else
            @all_users = current_unit.users.all
        end
    end
    
    def get_unit
        @all_units = Unit.all
    end
    
    def set_unit
        unit = Unit.find_by_id params[:unit]
        if unit
            session[:unit] = unit.id
            flash["success"] = "You're unit has successfully been saved as: " + unit.name
            redirect_to "/"
        else
            flash["danger"] = "That is not a valid unit"
            redirect to get_unit_path
        end
    end
    
      
    def get_shifts
        user = User.find_by_id(params[:id]) 
        shifts = user.shifts.all
        json_info = {}
        shifts.each do |shift|
            date = shift.date.strftime("%-m/%d")
            ws = shift.workshift
            time = ws.description or "" 
            name = ws.metashift.name 
            json_info[shift.id] = {}
            json_info[shift.id]["description"] = date + " " + name + " " + time
            json_info[shift.id]["hours"] = ws.length
        end
        render json: json_info
    end
    
    def get_all_shifts
        json_info = {}
        metashifts = current_unit.metashifts
        metashifts.each do |ms|
            workshifts = ms.workshifts
            
        end
        
    end
end
