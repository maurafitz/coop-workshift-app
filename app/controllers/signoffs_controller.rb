class SignoffsController < ApplicationController
    skip_before_filter :set_current_user
    require "pp"
    def new
        if current_unit.nil?
            flash[:danger] = "You have not set your unit yet. Please do so now"
            redirect_to get_unit_path
        else
            @all_users = current_unit.users.all
            @signed_off_shifts = Shift.get_signed_off_shifts current_unit
            @manager_rights = ((not current_user.nil?) and current_user.manager_rights?)
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
            redirect_to get_unit_path
        end
    end
      
    def get_shifts
        user = User.find_by_id(params[:id]) 
        shifts = user.shifts.all.where(date: 2.days.ago..1.week.from_now, completed: false)
        json_info = {}
        shifts.each do |shift|
            date = shift.date.strftime("%-m/%d")
            ws = shift.workshift
            json_info[shift.id] = {}
            json_info[shift.id]["description"] = date + " " + shift.get_name
            json_info[shift.id]["hours"] = ws.length
        end
        render json: json_info
    end
    
    def get_all_shifts
        json_info = {}
        metashifts = current_unit.metashifts
        metashifts.each do |ms|
            workshifts = ms.workshifts
            workshifts.each do |ws|
                shifts = ws.shifts.where(date: 2.days.ago..1.week.from_now, completed: false)
                shifts.each do |s|
                  begin
                    time = ws.day + " " + s.date.strftime("%-m/%d")
                    if not json_info.key? time
                        json_info[time] = {}
                    end
                    desc = ms.name + " " + ws.get_details
                    if not json_info[time].key? desc
                        json_info[time][desc] = []
                    end
                    u = s.user 
                    if not u 
                        json_info[time][desc] << {"name" => "Unassigned",
                                                    "id" => "",
                                                    "hours" => ws.length,
                                                    "shift_id" => s.id  }
                    end
                    if not json_info[time][desc].include? u.full_name
                        json_info[time][desc] << {"name" => u.full_name,
                                                    "id" => u.id,
                                                    "hours" => ws.length,
                                                    "shift_id" => s.id  }
                    end
                  rescue Exception => e
                    puts e.message
                  end
                end
            end
            end
        pp json_info
        render json: json_info
    end
    
    def submit
        signoff = params[:signoff]
        verifier_signed_in = signoff[:verifier_signed_in] == "true"
        if verifier_signed_in == true
            verif_user = current_user
        else
            verif_user = User.find_by_id(signoff[:verifier_id])
        end
        if not verifier_signed_in and not verif_user.authenticate(signoff[:verifier_pw])

            puts signoff[:verifier_pw]

            flash[:danger] = "Verifier PW not correct. Please try again"
            redirect_to signoff_page_path and return
        end
        
        u = User.find(signoff[:workshifter_id])
        if u.id == verif_user.id
            flash[:danger] = "You may not verify your own shifts"
            redirect_to signoff_page_path and return
        end
        
        type = signoff[:type]
        fields = signoff[ type ]
        if type != "special"
            s = Shift.find_by_id(fields[:shift_id])
        else
            if not verif_user.manager_rights?
                flash[:danger] = "Only managers or admins may sign off on special shifts"
                redirect_to signoff_page_path and return
            end
            s = Shift.new()
            ws = Workshift.new()
            ms = Metashift.new()
            s.workshift = ws
            ws.metashift = ms
            ws.length = fields[:shift_hr]
            ws.save
            ms.unit = u.unit
            ms.name = fields[:shift_desc]
            ms.save
            s.user = u
        end
        s.completed = true
        s.signoff_by = verif_user
        s.signoff_date = Time.now
        if s.save!
            flash[:success] = "You have successfully signed off a shift"
        else 
            flash[:danger] = "Error saving shift"
        end
        redirect_to signoff_page_path

    end
    
    def email_admin
        id = params[:id] 
        @shift = Shift.find(id)
        render(:partial => 'email_admin_form', :object => @shift) if request.xhr?
    end
end
