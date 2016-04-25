# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

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
unit_instances[0].policy = policy_instances[0]
unit_instances[1].policy = policy_instances[1]
unit_instances[0].save ; unit_instances[1].save


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
          :hour_balance => 10, :fine_balance => 50}
    	  ]
    	  
user_instances = []
users.each do |user|
    new_user =  User.create!(user)
    new_user.unit = unit_instances[0]
    new_user.save
    user_instances <<    new_user
end


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
                        :description => 'Coordinate waste reduction. Go to CO.'}
        }
          
metashift_instances = {}
metashifts.each do |metashift_name, metashift|
    m = Metashift.create!(metashift)
    m.unit = unit_instances[0]
    m.save
    metashift_instances[metashift_name] = m
end


## WORKSHIFTS ## 
workshifts = {
        :dishes => [{:start_time => "5am", :end_time => "11am", :length => 2, :day => "Monday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 5, :day => "Wednesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 1, :day => "Thursday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 2, :day => "Friday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 2, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 1, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 1, :day => "Monday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]}
                   ],
        :tidy => [{:start_time => "11am", :end_time => "2pm", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:tidy]}
                    {:start_time => "5am", :end_time => "11am", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 5, :day => "Wednesday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 1, :day => "Thursday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 2, :day => "Friday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "5am", :end_time => "11am", :length => 2, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 1, :day => "Saturday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 1, :day => "Monday", :metashift => metashift_instances[:dishes]},
                    {:start_time => "12pm", :end_time => "3pm", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:dishes]}
                   ],
        :tidy => [{:start_time => "11am", :end_time => "2pm", :length => 3, :day => "Tuesday", :metashift => metashift_instances[:tidy]}
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
w.user = c
w.save

## SHIFTS ##

shifts = [
    {:date => "April 20, 2016", :user => a, :workshift => workshift_instances[:dishes][2]},
    {:date => "April 25, 2016", :user => a, :workshift => workshift_instances[:dishes][0]},
    {:date => "April 25, 2016", :user => b, :workshift => workshift_instances[:dishes][7]},
    {:date => "April 26, 2016", :user => b, :workshift => workshift_instances[:dishes][1]},
    {:date => "April 26, 2016", :user => c, :workshift => workshift_instances[:tidy][0]},
    {:date => "April 27, 2016", :user => a, :workshift => workshift_instances[:dishes][2]},
    {:date => "April 28, 2016", :user => b, :workshift => workshift_instances[:dishes][3]},
    {:date => "April 29, 2016", :user => a, :workshift => workshift_instances[:dishes][4]},
    ]
    
shift_instances = []
shifts.each do |shift|
    s = Shift.create(shift)
    shift_instances << s
end

