class Policy < ActiveRecord::Base
    belongs_to :unit
    serialize :fine_days, Array
    
    def get_first_day
        if first_day
            first_day.strftime("%B %d, %Y")
        else
            nil
        end
    end
    
    def get_last_day
        if last_day
            last_day.strftime("%B %d, %Y")
        else
            nil
        end
    end
    
    def get_fine_days
        if fine_days
            arr = []
            str = ""
            fine_days.each do |date|
                arr << date.strftime("%B %d, %Y")
            end
            return arr.join(", ")
        else
            nil
        end
    end
    
    def is_fine_day?
        fine_days.each do |day|
            if day.today?
                return true
            end 
        end 
        false
    end 
    
    def fine_users
        #This should be executed every fining day
        unit.users.each do |user|
            user.fine_balance += fine_amount * user.hour_balance
            user.hour_balance = 0
            user.save
        end 
    end 
end
