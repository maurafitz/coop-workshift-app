require 'rails_helper'

RSpec.describe User, type: :model do
    before :each do
        @policy = Policy.create!(:first_day => "January 1, 2016",
            :last_day => "May 17, 2016", :fine_amount => 30,
            :fine_days => [Date.parse("February 5, 2016"), Date.parse("March 13, 2016"), Date.parse("April 25, 2016")],
            :market_sell_by => 3)
        @policy2 = Policy.create!(:first_day => "January 1, 2016",
            :last_day => "May 17, 2016", :fine_amount => 30,
            :fine_days => [Date.parse("February 5, 2016"), Date.today, Date.parse("April 25, 2016")],
            :market_sell_by => 3)
    end
    it "should get the first day of the semester as a string" do
        expect(@policy.get_first_day).to eq("January 01, 2016") 
    end
    it "should get the last day of the semester as a string" do
        expect(@policy.get_last_day).to eq("May 17, 2016") 
    end
    it "should get the fine days for the semester as a string" do
        expect(@policy.get_fine_days).to eq("February 05, 2016, March 13, 2016, April 25, 2016") 
    end
    it 'should say whether its a fining day or not' do
        expect(@policy2.is_fine_day?).to eq(true)
    end 
    
    describe 'fining users' do
        before :each do 
            @unit = Unit.create!()
            @policy = Policy.create!(:starting_hour_balance => 5.0, :fine_amount => 10,
            :fine_days => [Date.today], :unit => @unit)
            @member1 = User.create!(:first_name => 'Maura', :unit => @unit, :email => 'a@b.com',
                    :last_name => 'Fitz', :permissions => User::PERMISSION[:member],
                    :hour_balance => 5, :password => '12345kabsdfasdf')
            @member2 = User.create!(:first_name => 'Henri', :unit => @unit,:email => 'b@c.com',
                    :last_name => 'Fitz', :permissions => User::PERMISSION[:manager],
                    :hour_balance => 0,:password => '12345kabsdfsdfasdf')
            @policy.fine_users
        end 
        it 'should add correct dollar amount to each users fine balance' do
            expect(User.find(@member1.id).fine_balance).to eq(50)
            expect(User.find(@member2.id).fine_balance).to eq(0)
        end 
        it 'should reduce the users hour balance to zero' do
            expect(User.find(@member1.id).hour_balance).to eq(0)
            expect(User.find(@member2.id).hour_balance).to eq(0)
        end 
  end  
end
 