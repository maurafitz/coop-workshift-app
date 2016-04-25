class MetashiftsController < ApplicationController
    def create_metashift
        @metashifts_uploaded = []
        new_metashift = Metashift.new
        new_metashift.update_attributes(metashift_params)
        new_metashift.save
        @metashifts_uploaded << new_metashift
        render "workshifts/upload"
    end
    
    def upload
        if (not params[:file].blank?)
          begin
            new_shifts = Metashift.import(params[:file])
            @metashifts_uploaded = new_shifts
            render 'shifts/upload'
          rescue Exception => e
            flash[:danger] = e.message
            redirect_to new_workshift_path
          end
        else
          flash[:danger] = "You must select a file to upload."
          redirect_to new_workshift_path
        end
    end
    
    def metashift_params
        params.require(:metashift).permit(:category, :name, :description, :multiplier)
    end
end
