require 'rails_helper'
describe Unit do
    it { 
        should have_many(:users) 
        should have_one(:policy)
        should have_many(:metashifts)
    }
    
    it "should return lists of workshifts grouped by metashift and day" do
        @unit = Unit.create!(:name=>"Cloyne")
        @metashift1 = Metashift.create!()
        @metashift1.unit = @unit
        @workshift1 = Workshift.create!(:start_time => "10:00AM", :end_time => "1:00PM", :day => "Monday")
        @workshift1.metashift = @metashift1
        @metashift1.save
        @workshift1.save
        @result = {@metashift1 => {"Monday" => [@workshift1]}}
        expect(@unit.get_metashift_workshifts).to eq(@result)
    end
end