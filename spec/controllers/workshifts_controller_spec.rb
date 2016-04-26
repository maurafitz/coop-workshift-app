require 'rails_helper'
require "json"

RSpec.describe WorkshiftsController, type: :controller do
    before(:each) do 
        @user1 = create(:user, first_name: "Joe")
        @meta_shift = create(:metashift)
        @shift = create(:workshift, metashift: @meta_shift, user: @user1)
        @shift.save
    end
    # describe "creating a new shift" do
    #     before(:each) do
    #         get :new
    #     end
    #     it 'should select the New Metashifts template for rendering' do
    #         expect(response).to render_template(:new)
    #     end
    #     it 'should prepare a new instance of a shift' do
    #         get :new
    #         expect(assigns(:shift)).to be_a_new(Shift)
    #     end
    #     it 'should display as json correctly' do
    #         @shift.full_json
    #     end
    # end
    
    # describe 'preparing shift timeslots' do
    #     before(:each) do
    #         @a_user = User.create!(:first_name => 'my user', :last_name => 'last',
    #             :email => 'auser@gmail.com', :password => '3ljkd;a2', :permissions =>
    #             User::PERMISSION[:ws_manager])
    #         @user = User.find_by(:first_name => 'my user')
    #         request.session = { :user_id => @user.id }
    #         @shift1 = Shift.new
    #         @shift2 = Shift.create!(:start_time => DateTime.strptime("09/02/2009 17:00", "%m/%d/%Y %H:%M"),
    #                                 :end_time => DateTime.strptime("09/02/2009 19:00", "%m/%d/%Y %H:%M"),
    #                                 :metashift_id => '')
    #         @metashift = Metashift.create!(:category => "Kitchen", :description => 'dlka;jfd', :multiplier => 5)
    #     end

    #     it "should provide a new timeslot" do
    #         get :new_timeslots, :id => @metashift.id
    #         expect(response).to render_template("shifts/add_timeslots")
    #     end
        
    #     it "should update a shift" do
    #         expect{@shift2.update!(:start_time => DateTime.strptime("09/01/2009 17:00", "%m/%d/%Y %H:%M"))}.to change{@shift2.start_time}
    #     end
        
    #     it "should destroy a shift" do
    #         expect {@shift2.destroy} .to change{Shift.count}
    #     end
        
    # end
    
    # describe 'adding timeslots to a metashift' do
    #     before(:each) do
    #         @metashift = Metashift.create!(:category => "Kitchen",
    #         :description => 'dlka;jfd', :multiplier => 5, :id => 3)
    #         post :add_timeslots, 
    #         :shift => {:dayoftheweek => 'Tuesday', :start_time => '07:00AM',
    #             :end_time => '09:00AM', :metashift_id => '3'}
    #     end
    #     it 'should find the corresponding metashift' do
    #         expect(assigns(:metashift)).to be_a(Metashift)
    #     end
    #     it 'should redirect to shifts index on success' do
    #         expect(response).to redirect_to('/shifts')
    #     end
    # end
    
    describe 'deleting a workshift' do
        before(:each) do
            @metashift = Metashift.create!(:category => "Kitchen",
            :description => 'dlka;jfd', :multiplier => 5, :id => 3)
            @workshift2 = Workshift.create!(:start_time => '10am',
                                    :end_time => '11am',
                                    :metashift_id => '', :user => @user, :id => 20)
        end
        it 'should find the correct shift' do
            get :destroy, :id => 20
            expect(assigns(:workshift)).to be_a(Workshift)
        end
        it 'should destroy the shift if it exists' do
            expect { get :destroy, :id => 20 }.to change(Workshift, :count).by(-1)
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
                                    
            put :change_users, {:id => @workshift2.id, :user_ids => [@user2.id], 
                                  :shift_ids => [@workshift2.id]}
        end
        
        it 'should correctly update the user field of the shift' do
            shift = Workshift.find_by_id(@workshift2.id)
            (shift.user.id).should eq(@user2.id) 
        end
        
        it 'should update future shifts' do 
            shifts = @workshift2.get_future_shifts
            (shifts[0].user.id).should eq(@user2.id)
            (shifts[1].user.id).should eq(@user2.id)
        end 
        
        it 'should not update past shifts' do
            shifts = @workshift2.get_past_shifts
            (shifts[0].user.id).should eq(@user.id)
        end 
    end 
    
end