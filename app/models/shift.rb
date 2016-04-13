class Shift < ActiveRecord::Base
  belongs_to :metashift
  belongs_to :user
  
  def full_json
    self.as_json( include: [:metashift, :user] )
  end
  
  def self.add_shift(day, start_time, end_time, metashift)
    start_time = Chronic.parse('this ' + day + ' ' + start_time.to_str)
    end_time = Chronic.parse('this ' + day + ' ' + end_time.to_str)
    a_shift = Shift.create!(:start_time => start_time, :end_time => end_time)
    metashift.shifts << a_shift
  end
  
  def getTimeFormatted()
    time = self.start_time.strftime("%A") + ", " + self.start_time.strftime("%l:%M %p") + " to " + self.end_time.strftime("%l:%M %p")
    return time
  end
end
