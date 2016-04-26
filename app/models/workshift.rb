class Workshift < ActiveRecord::Base
    belongs_to :metashift
    has_many :shifts
    belongs_to :user
    
<<<<<<< HEAD
    before_save :update_future_shifts, if: :user_id_changed?
    
=======
    def get_name
        self.metashift.name
    end
    
    def get_unit
        self.metashift.unit
    end

>>>>>>> 27d55aadba5627a87f5d148ad0b7b76c79b35f13
    def self.add_workshift(day, start_time, end_time, metashift)
        new_workshift = Workshift.create!(:start_time => start_time, :end_time => end_time, :day => day)
        metashift.workshifts << new_workshift
        metashift.save!
        return new_workshift
    end
    
    def update_future_shifts
        shifts = self.get_future_shifts
        shifts.each do |shift|
            shift.user = user
            shift.save()
        end 
    end
    
    def get_future_shifts
        self.shifts.where(['date > ?', DateTime.now])
    end
    
    def get_past_shifts
        self.shifts.where(['date < ?', DateTime.now])
    end
    
    def get_details
        if not details
            return ""
        end
        details
    end
    
   def get_time_formatted
     return self.day + ", " + self.start_time + " to " + self.end_time
   end
   
  def full_json
    self.as_json( include: [:metashift, :user] )
  end
end
