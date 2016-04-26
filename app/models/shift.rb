class Shift < ActiveRecord::Base
  belongs_to :workshift
  belongs_to :user
  belongs_to :signoff_by, :class_name => "User"
  
  def full_json
    self.as_json( include: [:workshift, :user] )
  end
  
  def get_name
    self.workshift.get_name
  end
  
  def get_unit
    self.workshift.get_unit
  end
  
  def self.get_signed_off_shifts current_unit
    Shift.joins(workshift: {metashift: :unit}).
          includes(workshift: :metashift).
          where(shifts: {completed: true, date: 1.week.ago.to_date..Date.today}, units: {id: current_unit.id})
  end
  
  def get_date
    self.date.strftime("%A %_m/%e")
  end
  
  def get_signoff_datetime
    self.signoff_date.strftime('%l:%M%P %A %_m/%e')
  end
end
