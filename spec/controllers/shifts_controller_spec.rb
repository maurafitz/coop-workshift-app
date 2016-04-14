require 'rails_helper'
require "json"

RSpec.describe ShiftsController, type: :controller do
    before(:each) do 
        @user1 = create(:user, first_name: "Joe")
        @meta_shift = create(:metashift)
        @shift = create(:shift, metashift: @meta_shift, user: @user1)
        @shift.save
    end 
    
    describe "preparing a new shift" do
        before(:each) do
            get :new
        end
        it 'should provide a new form' do
            expect(response).to render_template(:new)
        end
        it 'should prepare a new instance of a shift' do
            get :new
            expect(assigns(:shift)).to be_a_new(Shift)
        end
        it 'should display as json correctly' do
            @shift.full_json
        end
    end
    
    describe 'preparing shift timeslots' do
        before(:each) do
            @a_user = User.create!(:first_name => 'my user', :last_name => 'last',
                :email => 'auser@gmail.com', :password => '3ljkd;a2', :permissions =>
                User::PERMISSION[:ws_manager])
            @user = User.find_by(:first_name => 'my user')
            request.session = { :user_id => @user.id }
            @shift1 = Shift.new
            @shift2 = Shift.create!(:start_time => DateTime.strptime("09/02/2009 17:00", "%m/%d/%Y %H:%M"),
                                    :end_time => DateTime.strptime("09/02/2009 19:00", "%m/%d/%Y %H:%M"),
                                    :metashift_id => '')
            @metashift = Metashift.create!(:category => "Kitchen", :description => 'dlka;jfd', :multiplier => 5)
        end

        it "should provide a new timeslot" do
            get :new_timeslots, :id => @metashift.id
            expect(response).to render_template("shifts/add_timeslots")
        end
        
        it "should update a shift" do
            expect{@shift2.update!(:start_time => DateTime.strptime("09/01/2009 17:00", "%m/%d/%Y %H:%M"))}.to change{@shift2.start_time}
        end
        
        it "should destroy a shift" do
            expect {@shift2.destroy} .to change{Shift.count}
        end
        
    end
    
    describe 'adding timeslots to a metashift' do
        before(:each) do
            @metashift = Metashift.create!(:category => "Kitchen",
            :description => 'dlka;jfd', :multiplier => 5, :id => 3)
            post :add_timeslots, 
            :shift => {:dayoftheweek => 'Tuesday', :start_time => '07:00AM',
                :end_time => '09:00AM', :metashift_id => '3'}
        end
        it 'should find the corresponding metashift' do
            expect(assigns(:metashift)).to be_a(Metashift)
        end
        it 'should redirect to shifts index on success' do
            expect(response).to redirect_to('/shifts')
        end
    end
    
    describe 'deleting a shift' do
        before(:each) do
            @metashift = Metashift.create!(:category => "Kitchen",
            :description => 'dlka;jfd', :multiplier => 5, :id => 3)
            @shift = Shift.create!(:start_time => '7:30AM', :end_time => '9:00AM',
            :metashift_id => 3, :id => 153)
            #get :destroy, :id => 153
        end
        it 'should find the correct shift' do
            get :destroy, :id => 153
            expect(assigns(:shift)).to be_a(Shift)
        end
        it 'should destroy the shift if it exists' do
            expect { get :destroy, :id => 153 }.to change(Shift, :count).by(-1)
        end
    end
    
    
    describe "index" do
        # it 'should return something from shifts#index' do
        #     puts "Shifts"
        #     puts Shift.all
        #     puts "End shifts"
        #     get :index
        #     assigns(:shifts).should_not be_nil
        # end
    end
end