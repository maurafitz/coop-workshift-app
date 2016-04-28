require 'rails_helper'
require 'pp'

RSpec.describe Shift, type: :model do
    before :each do
        @shifts = []
        for i in (1..12)
           num = 2 * i - 1
           shift = Shift.create!(:date => DateTime.now - num.days)
           if i.even?
               shift.signoff_date = DateTime.yesterday
               shift.save()
            end 
            @shifts << shift
        end
    end
    it "should get the blown shifts for the last 7 days" do
        blown = Shift.get_blown_shifts_last_n_days(7)
        (blown.size).should eq(4)
    end
end