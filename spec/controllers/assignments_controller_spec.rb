require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
    describe 'creating workshift assignments' do
        context 'when the current user is an admin' do
            before :each do
                @unit = double("Cloyne")
                @admin = double("Admin", :unit => @unit, :is_ws_manager? => true, :id => "0")
                @metashift_rows = double("Metashifts")
                @workshift1, @workshift2, @workshift3 = double("Workshift1"), double("Workshift2"), double("Workshift3")
                @user1, @user2 = double("User1"), double("User2")
                @workshifts = {"1" => @workshift1, "2" => @workshift2, "3" => @workshift3}
                @users = {"1" => @user1, "2" => @user2}
                @params = {"workshifts" => {"1"=> "1", "2" => "2", "3" => "1"}}
                
                allow(User).to receive(:find_by_id).and_return(@admin)
                allow(@unit).to receive(:get_metashift_workshifts).and_return(@metashift_rows)
                allow(Workshift).to receive(:find_by_id) do |id|
                    @workshifts[id]
                end
                @workshifts.each do |_, ws|
                    allow(ws).to receive(:user=) ; allow(ws).to receive(:save)
                end
                get :new
            end
            it 'should select the New Assignments template for rendering' do
                expect(response).to render_template('new')
            end
            it 'should get the current_unit workshifts grouped by metashift and make it available to that template' do
                expect(assigns(:metashift_rows)).to eq(@metashift_rows)
            end
            it 'should save the assignments by assigning each workshift to a user' do 
                allow(User).to receive(:find_by_id) do |id|
                    @users[id]
                end
                expect(@workshift1).to receive(:user=).with(@user1) 
                expect(@workshift2).to receive(:user=).with(@user2) 
                expect(@workshift3).to receive(:user=).with(@user1) 
                @workshifts.each do |_, ws|
                    expect(ws).to receive(:save)
                end
                post :create, @params
            end
            it "should redirect to the current user's profile page" do
                post :create, @params
                expect(response).to redirect_to(user_profile_path(@admin.id))
            end
        end
        context 'when the current user is a member ' do 
        end
        
        
        # before(:each) do
        #     @a_user = User.create!(:first_name => 'my user', :last_name => 'last',
        #     :email => 'auser@gmail.com', :password => '3ljkd;a2', :permissions =>
        #     User::PERMISSION[:ws_manager])
        #     request.session = { :user_id => @a_user.id }
        # end
        # it 'should call the assign method' do
        #     expect_any_instance_of(AssignmentsController).to receive(:assign_workshifts)
        #     post :create 
        # end
        # it 'should redirect to the user profile' do
        #     AssignmentsController.any_instance.stub(:assign_workshifts)
        #     post :create
        #     expect(response).to redirect_to("/users/#{@a_user.id}")
        # end
    end
end