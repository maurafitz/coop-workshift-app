require 'pp'
require 'chronic'

namespace :fine_calculator do
  desc "Runs every day (depending on Heroku's scheduler setup)
        Should do it seperately for each unit
        * Calculate blown shifts Sunday at midnight
        * When you blow a shift you should be subtracted double 
                the hrs that the shift (eg. 2 hrs of pots = -4 hrs if blown)
        * Every fining date you are fined the fining 
                rate*hrs down and your hrs are reset to 0
        * Adds policies#starting_hour_balance to every user every week
                (Should call Users#weekly_hours_addition)"
  task :start => :environment do
    pp "Scheduler woke up at #{Time.now}, iterating over recent shifts"
    if isSunday()
      pp 'Adding hours to all users based on their unit policy'
      User.weekly_hours_addition()
      findAndAddBlownShifts()
    end 
    checkFiningDays
  end
  
  def findAndAddBlownShifts
      pp 'Adding fine hours'
      users_to_fine = getUserSubtractionHash(Shift.get_blown_shifts_last_n_days(7))
      User.add_hours_from_blown(users_to_fine)
  end 
  
  def checkFiningDays
    Policy.all.each do |policy|
      fine_days = policy.get_fine_days
      
    end 
  end 
  
  def getShiftsForLastNDays(n)
      Shift.all.where(date: (Date.current - n.days)..Date.current)
  end 
  
  def getUserSubtractionHash(blown)
    #Multiplies blown hours by 2 and adds to hash
    user_hash = {}
    blown.each_with_object(Hash.new(0)) { |shift,counts| counts[shift.user_id] += (2 * shift.workshift.length) }
  end 
  
  def isSunday
    DateTime.now.wday == 0 #Only run on Sundays
  end
  
  
end