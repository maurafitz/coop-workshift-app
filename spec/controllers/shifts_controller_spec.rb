require 'rails_helper'
require "json"
require 'pp'

RSpec.describe ShiftsController, type: :controller do
    before(:each) do 
        @user1 = create(:user, first_name: "Joe")
        @meta_shift = create(:metashift)
        @shift = create(:workshift, metashift: @meta_shift, user: @user1)
        @shift.save
    end

    
    describe 'viewing shifts' do
        before(:each) do
            get :index
        end 
        
        it 'should load /shifts index' do
            expect(response).to render_template("shifts/index")
        end 
        
        it 'should assign serializedShifts' do
            assigns(:serializedShifts).should_not be_nil
        end 
        
        it 'should assign all users' do 
            users = User.all.to_json
            expect(assigns(:allUsers)).to eq(users)
        end 
    end
    
    describe 'deleting a shift' do
        before(:each) do
            @d_user = User.find_by(:first_name => 'my user')
            @workshift = Workshift.create!(:start_time => '10am',
                                    :end_time => '11am', :day=> 'Monday',
                                    :metashift_id => '', :user => @d_user, :id => 20)
            @shift = Shift.create!(:workshift=> @workshift, :date => DateTime.yesterday, 
                                    :user => @d_user, :id=> 153)
            #get :destroy, :id => 153
        end
        it 'should find the correct shift' do
            get :destroy, :id => 153
            expect(assigns(:shift)).to be_a(Shift)
        end
        it 'should destroy the shift if it exists' do
            expect { get :destroy, :id => 153 }.to change(Shift, :count).by(-1)
        end
        
        it 'should remove the shift reference from the workshift' do
            get :destroy, :id => 153
            expect(@workshift.shifts).to eq([])
        end 
    end
    
    describe 'updating a shift' do
        before(:each) do
            @a_user = User.create!(:first_name => 'my user', :last_name => 'last',
                :email => 'auser@gmail.com', :password => '3ljkd;a2', :permissions =>
                User::PERMISSION[:ws_manager])
            @user = User.find_by(:first_name => 'my user')
            @user2 = User.create!(:first_name => 'my user2', :last_name => 'last2',
                :email => 'auser2@gmail.com', :password => '3ljkd;a3', :permissions =>
                User::PERMISSION[:ws_manager])
            @user2 = User.find_by(:first_name => 'my user2')
            @workshift2 = Workshift.create!(:start_time => '10am',
                                    :end_time => '11am',
                                    :metashift_id => '', :user => @user, :id => 20)
            @metashift = Metashift.create!(:category => "Kitchen", :description => 'dlka;jfd', :multiplier => 5)
            @shift1 = Shift.create!(:workshift=> @workshift2, :date => DateTime.yesterday, 
                                    :user => @user)
            @shift2 = Shift.create!(:workshift=> @workshift2, :date => 5.hours.from_now, 
                                    :user => @user)
            @shift3 = Shift.create!(:workshift=> @workshift2, :date => 1.day.from_now, 
                                    :user => @user)
                                    
            put :change_users, {:id => @shift1.id, :user_ids => [@user2.id], 
                                  :shift_ids => [@shift1.id]}
        end
        
        it 'should correctly update the user field of the shift' do
            put :change_users, {:id => @shift1.id, :user_ids => [@user2.id], 
                                  :shift_ids => [@shift1.id]}
            shift = Shift.find_by_id(@shift1.id)
            (shift.user.id).should eq(@user2.id) 
        end
        
        it 'should not change the parent workshifts user field' do 
            (@workshift2.user.id).should eq(@user.id)
        end 
        
        it 'should not update other shifts under the same workshift' do
            shifts = @workshift2.shifts.where('id != ?', @shift1.id)
            (shifts[0].user.id).should eq(@user.id)
        end 
    end 
end