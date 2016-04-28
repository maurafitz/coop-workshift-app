require 'rails_helper'
require 'pp'

RSpec.describe User, type: :model do
 
  describe "check permissions" do
    before(:each) do
      @member1 = FactoryGirl.build(:user, :first_name => 'Maura',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:member])
      @member2 = FactoryGirl.build(:user, :first_name => 'Henri',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:manager])
    end
    
    it 'should give a member only member access' do
        mem1 = @member1.is_member?
        expect(mem1).to be_truthy
        man1 = @member1.is_manager?
        expect(man1).to be_falsy
        ws1 = @member1.is_ws_manager?
        expect(ws1).to be_falsy
    end
    
    it 'should make a manager only have manager access' do
      expect(@member2.is_manager?).to be_truthy
      expect(@member2.is_member?).to be_falsy
      expect(@member2.is_ws_manager?).to be_falsy
    end
    
    it 'should have a correct full name' do
      expect(@member1.full_name).to eq("Maura Fitz")
      expect(@member2.full_name).to eq("Henri Fitz")
    end
  end
  
  describe "the password" do
    it 'should be 8 digits' do
      pw = User.random_pw
      expect(pw.length).to eq(8)
    end
  end
  
  describe "uploading a file" do
    it 'should error if an unknown type is uploaded' do
      @file = double()
      allow(@file).to receive(:original_filename).and_return('test.xml')
      expect {User.open_spreadsheet(@file)}.to raise_error(RuntimeError)
    end
  end
  
  describe 'updating hour balance' do
    before(:each) do
      @unit = Unit.create!()
      @policy = Policy.create!(:starting_hour_balance => 5.0, 
       :unit => @unit)
       @member1 = User.create!(:first_name => 'Maura', :unit => @unit, :email => 'a@b.com',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:member],
      :hour_balance => 0, :password => '12345kabsdfasdf')
      @member2 = User.create!(:first_name => 'Henri', :unit => @unit,:email => 'b@c.com',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:manager],
      :hour_balance => 0,:password => '12345kabsdfsdfasdf')
      
    end
    
    it 'should add 5 to each users balance' do 
      User.weekly_hours_addition()
      pp User.all
      (User.find(@member1.id).hour_balance).should eq(5)
    end 
  end 
end
