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
            expect(blown.size).to eq(4)
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
        it 'should return the correctly formatted date of signoff' do
            times = {DateTime.parse('4th Feb 2016 04:05:00 PM') => "4:05pm Thursday 2/4", 
                     DateTime.parse('12th Feb 2016 12:05:00 PM') => "12:05pm Friday 2/12", 
                     DateTime.parse('1st Oct 2016 04:15:00 AM') => "4:15am Saturday 10/1", 
                     DateTime.parse('10th Oct 2016 12:15:00 AM') => "12:15am Monday 10/10"}
            shifts = []
            times.each do |time, result|
                shifts << [Shift.new(:signoff_date => time), result]
            end
            shifts.each do |shift, time|
                expect(shift.get_signoff_datetime).to eq(time)
            end
        end       
    end
end