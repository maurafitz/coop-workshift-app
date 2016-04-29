class Workshift < ActiveRecord::Base
  belongs_to :metashift
  has_many :shifts
  belongs_to :user
  validates :start_time, format: { with: /\d?\d:\d\d(A|a|P|p)(m|M)/, message: ": enter correct format, ex. 12:30, then select AM or PM" }
  validates :end_time, format: { with: /\d?\d:\d\d(A|a|P|p)(m|M)/, message: ": enter correct format, ex. 12:30, then select AM or PM" }
  validates :day, :inclusion => {:in => %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday Sunday), :message => ': please select a weekday.'}
  before_save :update_future_shifts, if: :user_id_changed?
  
  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  
  def self.days
    DAYS
  end
  
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

  def self.add_workshift(day, start_time, end_time, metashift, length=1)
    new_workshift = Workshift.new(:start_time => start_time, :end_time => end_time, :day => day, :length => length)
    if (new_workshift.save) 
      metashift.workshifts << new_workshift
      metashift.save!
      return new_workshift
    else
      return new_workshift.errors
    end
    
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
