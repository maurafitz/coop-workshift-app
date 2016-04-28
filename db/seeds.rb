# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'chronic'

Avail.destroy_all
Preference.destroy_all
Metashift.destroy_all
User.destroy_all
Policy.destroy_all
Workshift.destroy_all
Shift.destroy_all
Unit.destroy_all


## POLICIES ## 
policies = [{:first_day => "January 1, 2016",  :last_day => "May 17, 2016",
             :fine_amount => 30, :fine_days => [Date.parse("April 13, 2016")],
             :market_sell_by => 3},
            {:first_day => "August 20, 2016",  :last_day => "December 20, 2016",
             :fine_amount => 10, :fine_days => [Date.parse("April 13, 2016"), Date.parse("April 19, 2016")],
             :market_sell_by => 32}
            ]
           
policy_instances = []  
policies.each do |policy|
    policy_instances <<  Policy.create!(policy) 
end


## UNITS ## 
units = [{:name => "Cloyne"}, 
         {:name => "Castro"}, 
         {:name => "CZ"}]

unit_instances = []
units.each do |unit|
    unit_instances <<    Unit.create!(unit) 
end
cloyne, castro, cz = unit_instances
cloyne.policy = policy_instances[0]
castro.policy = policy_instances[1]
cloyne.save ; castro.save

## USERS ## 
users = [{:first_name => 'admin', :last_name => 'Z', 
          :email => 'coop_admin@berkeley.edu', 
          :permissions => User::PERMISSION[:ws_manager],
          :password => 'admin', :has_confirmed => true,
          :hour_balance => 5, :fine_balance => 40},
          {:first_name => 'member', :last_name => 'A', 
          :email => 'coop_member@berkeley.edu', 
          :permissions => User::PERMISSION[:member],
          :password => 'member', :has_confirmed => true,
          :hour_balance => 2, :fine_balance => 10},
          {:first_name => 'manager', :last_name => 'S', 
          :email => 'coop_manager@berkeley.edu', 
          :permissions => User::PERMISSION[:manager],
          :password => 'manager', :has_confirmed => true,
          :hour_balance => 10, :fine_balance => 50},
          {:first_name => 'Giorgia', :last_name => 'Willits', 
          :email => 'gw@berkeley.edu', 
          :permissions => User::PERMISSION[:manager],
          :password => 'gwillits', :has_confirmed => true,
          :hour_balance => 10, :fine_balance => 50},
    	  ]
    	  
faker_users = []
(0..100).each {
    faker_users << User.create!({:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, 
          :email => Faker::Internet.email, 
          :permissions => User::PERMISSION[:member],
          :password => 'member', :has_confirmed => true,
          :hour_balance => Faker::Number.between(1, 50), :fine_balance => Faker::Number.between(20, 100),
          :sent_confirmation => true, :has_confirmed => true, :unit => cloyne })
}
    	  
user_instances = []
users.each do |user|
    new_user =  User.create!(user)
    new_user.unit = cloyne
    new_user.save
    user_instances <<    new_user
end
giorgia = user_instances[3]
giorgia.unit = castro
giorgia.save


## METASHIFTS ## 
metashifts = {:tidy => {:category => 'Cleaning', :name => 'Tidy Common Areas', :description => 'Laundry Rooms: 
                         1. Wipe off the tops of all the washers, dryers, and counters with a wet rag.
                         2. Bring the lost and found bin to the Freepile if it has not been emptied in a week.
                         3. Clear the lint collectors of all dryers that not in use. 
                         4. Organize bottles of detergent and empty the lint bin into compost.
                         5. Sweep the floor.
                         
                         Study Rooms: 
                         1. Bring the lost and found bin to the Freepile if it has not been emptied in a week.
                         2. Clear off all tables completely. Put any personal items in the box until next week. 
                         3. Clean off tables with bleach solution and a rag.
                         4. Pick up all garbage and take to dumpster, including trash in the hallways. Empty the recycling bins.
                         5. Take all dishes to the dishwash area. Compost leftover food and rinse before placing them in the bins.
                         6. Organize the furniture and sweep the floor.',
                         :multiplier => 2.0},
            :kitchen_manager => {:category => 'Kitchen', :name => 'Kitchen Manager', :multiplier => 1,
                        :description => 'Refer to bylaws for manager description.'},
            :dishes => {:category => 'Kitchen', :name => 'Dishes', :multiplier => 1,
                        :description => 'Use a sponge and soap to scrub off each dish.'},
            :head_cook => {:category => 'Kitchen', :name => 'Head Cook', :multiplier => 1,
                        :description => 'Lead a team in cooking meals.'},
            :trc => {:category => 'Garbage', :name => 'TRC (Trash, Recycling, Compost)', :multiplier => 1,
                       :description => 'Take out trash, recycling and compost bins.'},
            :wrc => {:category => 'Garbage', :name => 'Waste Reduction Coordinator', :multiplier => 1,
                        :description => 'Coordinate waste reduction weekly. Go to CO.'}
        }
          
metashift_instances = {}
metashifts.each do |metashift_name, metashift|
    m = Metashift.create!(metashift)
    m.unit = unit_instances[0]
    m.save
    metashift_instances[metashift_name] = m
end
head_cook =  metashift_instances[:head_cook]
head_cook.unit = unit_instances[1]
head_cook.save

categories = ['Board', 'Central', 'Common Space', 'Crew', 'Food', 'Kitchen', 'Manager', 'Uncategorized', 'Cleaning', 'Garbage', 'Gardening' ]
faker_metashifts = []
(0..25).each {
    faker_metashifts << Metashift.create!({:category => categories[rand(11)], :name => Faker::Lorem.word, :multiplier => Faker::Number.between(1, 5),
                        :description => Faker::Lorem.paragraph(rand(20)), :unit => cloyne})
}

## PREFERENCES ##
faker_users.each do |user|
    faker_metashifts.each do |metashift|
        Preference.create!({:user => user, :metashift => metashift, :rating => 1+rand(5), :cat_rating => 1+rand(5)})
    end
end

## AVAILABILITIES ##
statuses = ["Available", "Available", "Available", "Available", "Unavailable", "Not Preferred", "Not Preferred", "Unsure"]
faker_users.each do |user|
    (0..6).each do |day|
        (8..23).each do |hour|
            Avail.create!({:day => day, :hour => hour, :user => user, :status => statuses[rand(8)]})
        end
    end
end


string_day_to_int = {"Sunday" => 0,"Monday" => 1, "Tuesday" => 2, 'Wednesday' => 3, 'Thursday' => 4, "Friday"=> 5, "Saturday" => 6, 'Weeklong' => 0}

## WORKSHIFTS ## 
workshifts = {
        :dishes => [{:start_time => "5am", :end_time => "11am", :details => "Morning", :length => 2, :day => "Monday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :details => "Morning",:length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :details => "Morning",:length => 5, :day => "Wednesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :details => "Morning",:length => 1, :day => "Thursday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :details => "Morning",:length => 2, :day => "Friday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :details => "Morning",:length => 2, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :details => "Afternoon",:length => 1, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :details => "Afternoon",:length => 1, :day => "Monday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :details => "AFternoon",:length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]}
                   ],
        :tidy => [{:start_time => "11am", :end_time => "2pm", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:tidy]}
                 ],
        :head_cook => [{:start_time => "5pm", :end_time => "8pm", :length => 2, :day => "Tuesday", :metashift => metashift_instances[:head_cook]}
                 ],
        :wrc => [{ :length => 5, :day => "Weeklong", :metashift => metashift_instances[:wrc]}
                 ]
        }
           
workshift_instances = {}
workshifts.each do |workshift_name, workshift_hashes|
    workshift_instances[workshift_name] = []
    workshift_hashes.each do |workshift|
        w = Workshift.create!(workshift)
        workshift_instances[workshift_name] << w
    end
end

a = user_instances[0]
b = user_instances[1]
c = user_instances[2]

(0...workshift_instances[:dishes].length).each do |i|
    w = workshift_instances[:dishes][i]
    if i.even?
        w.user = a
    else
        w.user = b
    end
    w.save
end
w = workshift_instances[:tidy][0]
w.user = a
w.save

Workshift.all.where('user_id' => nil).each do |ws|
    ws.user = a 
    ws.save
end 

days = Workshift.days
(0..200).each {
    start_time = rand(8..22)
    end_time = rand(start_time+1..23)
    length = 1 + rand(end_time-start_time)
    if start_time > 12
        start_time = (start_time-12).to_s + "pm"
    else
        start_time = start_time.to_s + "am"
    end
    if end_time > 12
        end_time = (end_time-12).to_s + "pm"
    else
        end_time = end_time.to_s + "am"
    end
    w = Workshift.create!({:start_time => start_time, :end_time => end_time, :details => Faker::Lorem.word,
                            :length => length, :day => days[rand(7)], :metashift => faker_metashifts[rand(26)]})
}

## SHIFTS ##

shifts = [
    {:date => "April 20, 2016", :user => a, :workshift => workshift_instances[:dishes][2]},
    {:date => "April 24, 2016", :user => a, :workshift => workshift_instances[:wrc][0]},
    {:date => "April 25, 2016", :user => a, :workshift => workshift_instances[:dishes][0]},
    {:date => "April 25, 2016", :user => b, :workshift => workshift_instances[:dishes][0]},
    {:date => "April 25, 2016", :user => b, :workshift => workshift_instances[:dishes][7]},
    {:date => "April 26, 2016", :user => b, :workshift => workshift_instances[:dishes][1]},
    {:date => "April 26, 2016", :user => c, :workshift => workshift_instances[:tidy][0]},
    {:date => "April 27, 2016", :user => a, :workshift => workshift_instances[:dishes][2]},
    {:date => "April 28, 2016", :user => b, :workshift => workshift_instances[:dishes][3]},
    {:date => "April 29, 2016", :user => a, :workshift => workshift_instances[:dishes][4]},
    {:date => "May 1, 2016", :user => a, :workshift => workshift_instances[:wrc][0]},
    {:date => "April 13, 2016", :user => a, :workshift => workshift_instances[:dishes][2], :completed => true, :signoff_by => b, :signoff_date => "April 13, 2016"},
    {:date => "April 18, 2016", :user => a, :workshift => workshift_instances[:dishes][0], :completed => true, :signoff_by => b, :signoff_date => "April 18, 2016"},
    {:date => "April 18, 2016", :user => b, :workshift => workshift_instances[:dishes][7], :completed => true, :signoff_by => c, :signoff_date => "April 19, 2016"},
    {:date => "April 19, 2016", :user => b, :workshift => workshift_instances[:dishes][1], :completed => true, :signoff_by => a, :signoff_date => "April 19, 2016"},
    {:date => "April 19, 2016", :user => c, :workshift => workshift_instances[:tidy][0], :completed => true, :signoff_by => b, :signoff_date => "April 19, 2016"},
    {:date => "April 20, 2016", :user => a, :workshift => workshift_instances[:dishes][2], :completed => true, :signoff_by => c, :signoff_date => "April 20, 2016"},
    {:date => "April 21, 2016", :user => b, :workshift => workshift_instances[:dishes][3], :completed => true, :signoff_by => c, :signoff_date => "April 22, 2016"},
    {:date => "April 22, 2016", :user => a, :workshift => workshift_instances[:dishes][4], :completed => true, :signoff_by => b, :signoff_date => "April 22, 2016"},
    {:date => "April 22, 2016", :user => a, :workshift => workshift_instances[:dishes][4], :completed => true, :signoff_by => b, :signoff_date => "April 22, 2016"},
    {:date => "April 22, 2016", :user => giorgia, :workshift => workshift_instances[:head_cook][0], :completed => true, :signoff_by => b, :signoff_date => "April 22, 2016"},
    ]
    
shift_instances = []
shifts.each do |shift|
    s = Shift.create(shift)
    shift_instances << s
end

# def make_shifts(weeks_before, weeks_after)
#     shifts = []
#     date = Date.today
#     Workshift.all.each do | workshift |
#         date = Chronic.parse("#{workshift.day} at #{workshift.start_time}")
#         if not workshift.day or not workshift.start_time or not date
#             puts "No workshift/workshift start_time for #{workshift}, defaulting shifts to Sunday at 3pm"
#             date = Chronic.parse("Sunday at 3pm")
#         end
#         (-weeks_after..weeks_before).each do |i|
#             shifts << {:date => date - i.weeks, :user => workshift.user, :workshift => workshift}
#         end 
#     end
#     shifts.each do |s|
#         new_shift = Shift.create!(s)
#     end 
# end

# make_shifts(1, 0)