require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
    describe 'create' do
        before(:each) do
            @a_user = User.create!(:first_name => 'my user', :last_name => 'last',
            :email => 'auser@gmail.com', :password => '3ljkd;a2', :permissions =>
            User::PERMISSION[:ws_manager])
            request.session = { :user_id => @a_user.id }
        end
        it 'should call the assign method' do
            expect_any_instance_of(AssignmentsController).to receive(:assign_workshifts)
            post :create 
        end
        it 'should redirect to the user profile' do
            AssignmentsController.any_instance.stub(:assign_workshifts)
            post :create
            expect(response).to redirect_to("/users/#{@a_user.id}")
        end
    end
end