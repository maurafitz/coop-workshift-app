require 'rails_helper'
require 'pp'

RSpec.describe User, type: :model do
 
  describe "check permissions" do
    before(:each) do
      @member1 = FactoryGirl.build(:user, :first_name => 'Maura',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:member])
      @member2 = FactoryGirl.build(:user, :first_name => 'Henri',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:manager])
      @member3 = FactoryGirl.build(:user, :first_name => 'Lol',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:ws_manager])
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
    
    it 'getPermission should return the correct string' do
      expect(@member1.getPermission).to eq("Member")
      expect(@member2.getPermission).to eq("Manager")
      expect(@member3.getPermission).to eq("Workshift-Manager")
    end
    
    it 'should map a role to the correct permission code' do
     expect(User.getPermissionCode("member")).to eq(0)
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
  

  describe 'checking availability' do
    it 'should return false if has no avails' do
      @member1 = User.create!(:first_name => 'Maura', :unit => @unit, :email => 'a@b.com',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:member],
      :hour_balance => 0, :password => '12345kabsdfasdf')
      (@member1.has_saved_availability?).should eq(false)
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
      (User.find(@member1.id).hour_balance).should eq(5)
      (User.find(@member2.id).hour_balance).should eq(5)
    end 
    
    it 'should add correct number of hours from blown hash' do
      user_blown_hours = {@member1.id => 10, @member2.id => 20}
      User.add_hours_from_blown(user_blown_hours)
      (User.find(@member1.id).hour_balance).should eq(10)
      (User.find(@member2.id).hour_balance).should eq(20)
    end 
  end 

  describe "converting time" do
    before(:each) do
      @member1 = FactoryGirl.build(:user, :first_name => 'Maura',
      :last_name => 'Fitz', :permissions => User::PERMISSION[:member])
    end
    it 'should convert to military time' do
      expect(@member1.convert_to_military('07:40AM')).to eq(7)
      expect(@member1.convert_to_military('07:40PM')).to eq(19)
    end
  end
  
  describe "checking user avalibility" do
    before(:each) do
      @member1 = User.create!(:first_name => 'Ryan', :last_name => 'Riddle',
        :permissions => User::PERMISSION[:member], :password => 'saef', :email => 'ry@berkeley.edu')
      @workshift1 = Workshift.create!(:day => 'Monday', :start_time => '1:00pm', :end_time => '2:00pm')
      @workshift2 = Workshift.create!(:day => 'Monday', :start_time => '6:00pm', :end_time => '8:00pm')
      @member2 = User.create!(:first_name => 'Maura', :last_name => 'Fitz',
        :permissions => User::PERMISSION[:member], :password => 'awef', :email => 'm@berkeley.edu')
      Avail.create!(:day => 0, :hour => 13, :status => 'Available', :user => @member2)
      Avail.create!(:day => 0, :hour => 18, :status => 'Unavailable', :user => @member2)
    end

    it "should show that I am not avaliable because no avails" do
      expect(@member1.is_available?(@workshift1)).to be false
    end

    it "should show that I am avaliable" do
      expect(@member2.is_available?(@workshift1)).to be true
    end
    
    it "should show that I am not avaliable because unavaliable" do
      expect(@member2.is_available?(@workshift2)).to be false
    end
  end
  
  describe "get rankings for workshifts" do
    before(:each) do
      @unit = Unit.create!(:name => 'ChillerCoop')
      @member1 = User.create!(:first_name => 'Ryan', :last_name => 'Riddle', :password => 'saef',
                              :email => 'ry@berkeley.edu', :unit => @unit)
      @member2 = User.create!(:first_name => 'Yannie', :last_name => 'Yip', :password => 'saef',
                              :email => 'yy@berkeley.edu', :unit => @unit)       
      @preference1 = Preference.create!(:user => @member1, :rating => 5, :cat_rating => 5, :metashift => @metashift1)
      @preference2 = Preference.create!(:user => @member2, :rating => 4, :cat_rating => 4, :metashift => @metashift1)
      
      @metashift1 = Metashift.create!(:category => 'Kitchen', :unit => @unit)
      @workshift1 = Workshift.create!(:day => 'Monday', :start_time => '1:00pm',
                                      :end_time => '2:00pm', :metashift => @metashift1)
                        
      allow(@member1).to receive(:is_available?).with(:ws).and_return(true)
      allow(@member1).to receive(:is_available?).with(:ws).and_return(true)
    end
    
    it "should return users and rankings sorted by ranking for the workshift" do
      @result = {@member1 => 5, @member2 => 4}
      # expect(User.get_rankings_for(@workshift1)).to eq(@result)
    end
  end
end
