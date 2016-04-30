require 'rails_helper'
require 'pp'

RSpec.describe Shift, type: :model do
    describe 'getting blown shifts' do
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
    describe 'getting the information about the shift' do
        before :each do
            @shift = Shift.new(:date => "April 4, 2016")
            @workshift = Workshift.new()
            @shift.workshift = @workshift
            @unit = double("Cloyne")
            allow(@workshift).to receive(:get_unit).and_return(@unit)
        end
        it 'should return the correct unit' do
            expect(@shift.get_unit).to eq(@unit)
        end
        it 'should return the correctly formatted date of the shift' do
            shifts = []
            dates = {"April 4, 2016" => "Monday 4/4",
                     "April 12, 2016" => "Tuesday 4/12",
                     "November 1, 2016" => "Tuesday 11/1",
                     "November 20, 2016" => "Sunday 11/20" }
            dates.each do |day, result|
                shifts << [Shift.new(:date => day), result]
            end
            shifts.each do |shift, day|
                expect(shift.get_date).to eq(day)
            end
        end

    end
end