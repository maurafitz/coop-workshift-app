require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
    before :each do
        @unit = double("cloyne")
        @admin = double("Admin", :unit => @unit, :is_ws_manager? => true, :id => "0")
        allow(User).to receive(:find_by_id).and_return(@admin)
    end
    describe 'creating workshift assignments' do
        context 'when the current user is an admin' do
            before :each do
                @metashift_rows = double("Metashifts")
                @ws1, @ws2, @ws3, @ws4= double("Workshift1"), double("Workshift2"), double("Workshift3"), double("Workshift4")
                @user1, @user2 = double("User1"), double("User2")
                @workshifts = {"1" => @ws1, "2" => @ws2, "3" => @ws3, "4" => @ws4}
                @users = {"1" => @user1, "2" => @user2}
                @params = {"workshifts" => {"1"=> "1", "2" => "2", "3" => "1", "4" => ""}}
                
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
                expect(@ws1).to receive(:user=).with(@user1) 
                expect(@ws2).to receive(:user=).with(@user2) 
                expect(@ws3).to receive(:user=).with(@user1)
                expect(@ws4).to receive(:user=).with(nil)
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
    end
    describe 'providing json for the workshift' do
        before :each do
            @workshift = double("workshift", :id => 0)
            @params = {"id" => @workshift.id}
            @user1 = double("user1", :last_name => 'Willits', :id => 1, :full_name => "Giorgia Willits")
            @user2 = double("user2", :last_name => 'Nelson', :id => 3, :full_name => "Eric Nelson")
            @sorted_users_rankings = {@user1 => 4, @user2 => 1}
            allow(Workshift).to receive(:find_by_id).and_return(@workshift)
            allow(User).to receive(:get_rankings_for).and_return(@sorted_users_rankings)
        end
        it 'should get the selected workshift' do 
            expect(Workshift).to receive(:find_by_id).with(@workshift.id.to_s)
            get :sort_users, @params
            expect(assigns(:workshift)).to eq(@workshift)
        end
        it 'should get all available users rankings for that workshift' do
            expect(User).to receive(:get_rankings_for).with(@workshift)
            get :sort_users, @params
            expect(assigns(:sorted_users_rankings)).to eq(@sorted_users_rankings)
        end
        it 'should create a row for each available user' do
            @rows = []
            @sorted_users_rankings.each do |user, ranking|
                expect(user).to receive(:last_name)
                expect(user).to receive(:id)
                expect(user).to receive(:full_name)
                @rows << {:name => "<a id='#{user.last_name}' href='#{admin_view_user_path(user.id)}'>#{user.full_name}</a>", :ranking => ranking}
            end
            get :sort_users, @params
            expect(assigns(:rows)).to eq(@rows)
        end
        # it 'should render json with the table rows' do
            # get :sort_users, @params
            # expect(response).to render_json
        # end
    end
end