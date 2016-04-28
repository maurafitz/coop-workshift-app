class Shift < ActiveRecord::Base
  belongs_to :workshift
  belongs_to :user
  belongs_to :signoff_by, :class_name => "User"
  
  def full_json
    self.as_json(:include=> {:workshift=> {:include=> :metashift}, 
    :user => {}} )
  end
  
  def get_name
    self.workshift.get_name
  end
  
  def get_unit
    self.workshift.get_unit
  end
  
  def self.get_signed_off_shifts current_unit
    joins(workshift: {metashift: :unit}).
    includes(workshift: :metashift).
    where(shifts: {completed: true, date: 1.week.ago.to_date..Date.today}, units: {id: current_unit.id})
  end
  
  def self.get_signed_off_for user
    joins(workshift: :metashift).
    includes(workshift: :metashift).
    where(shifts: {completed: true, user_id: user.id})
  end
  
  def get_date
    self.date.strftime("%A %_m/%e")
  end
  
  def get_signoff_datetime
    self.signoff_date.strftime('%l:%M%P %A %_m/%e')
  end
  
  def self.get_blown_shifts_last_n_days(n)
    shifts = Shift.all.where(date: (Date.current - n.days)..Date.current)
    blown = []
    shifts.each do |shift|
      if not (shift.completed or shift.signoff_date)
        blown << shift
      end 
    end
    blown
  end 
  
  
end
