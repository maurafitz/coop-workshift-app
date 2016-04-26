class Workshift < ActiveRecord::Base
  belongs_to :metashift
  has_many :shifts
  belongs_to :user
  
  before_save :update_future_shifts, if: :user_id_changed?
  
  def get_name
    name = self.metashift.name
    details = self.get_details
    if details != ""
      name + ": " + details
    else
      name
    end
  end
  
  def get_unit
    self.metashift.unit
  end
  
  def get_category
    self.metashift.category
  end
  
  def get_description
    self.metashift.description
  end

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
  
  def self.get_assignments_for user
    joins(:metashift).
    includes(:metashift).
    where(workshifts: {user_id: user.id})
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
   
  def get_start_end_time
    self.start_time + " to " + self.end_time
  end
   
  def full_json
    self.as_json( include: [:metashift, :user] )
  end
end
