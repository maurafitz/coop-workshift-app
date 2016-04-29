require 'rails_helper'

RSpec.describe Workshift, type: :model do
    it { 
        should belong_to(:user) 
        should have_many(:shifts)
        should belong_to(:metashift)
    }
    
    before :each do
        @workshift = Workshift.new(:start_time => "10am", :end_time => "1pm", :day => "Monday", :length => "3")
    end
    
    it "should return the correct formatted time do" do
        expect(@workshift.get_time_formatted).to eq("Monday, 10am to 1pm")
    end
end
    
