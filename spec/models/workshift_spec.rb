require 'rails_helper'

RSpec.describe Workshift, type: :model do
    it { 
        should belong_to(:user) 
        should have_many(:shifts)
        should belong_to(:metashift)
    }
    
    before :each do
        @workshift = Workshift.new(:start_time => "10am", :end_time => "1pm", :day => "Monday", :length => "3")
        @metashift = Metashift.new(:name => "Default", :category => "Default Category", :description => "Default Description", :multiplier => 2.0, :id => 0)
        @workshift.metashift = @metashift
        @unit = double("Cloyne")
        allow(@workshift).to receive(:get_unit).and_return(@unit)
    end
    
    it "should return correct metashift name of shift" do
        expect(@workshift.get_name).to eq("Default")
    end
    
    it "should return correct formatted time do" do
        expect(@workshift.get_time_formatted).to eq("Monday, 10am to 1pm")
    end
    
    it "should return correct start and end time" do
        expect(@workshift.get_start_end_time).to eq("10am to 1pm")
    end
end