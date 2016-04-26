class Workshift < ActiveRecord::Base
    belongs_to :metashift
    has_many :shifts
    belongs_to :user
    
    def get_name
        self.metashift.name
    end
    
    def get_unit
        self.metashift.unit
    end

    def self.add_workshift(day, start_time, end_time, metashift)
        new_workshift = Workshift.create!(:start_time => start_time, :end_time => end_time, :day => day)
        metashift.workshifts << new_workshift
        metashift.save!
        return new_workshift
    end

   def get_time_formatted
     return self.day + ", " + self.start_time + " to " + self.end_time
   end
   
  def full_json
    self.as_json( include: [:metashift, :user] )
  end
end
