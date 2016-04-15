require 'rails_helper'

RSpec.describe Preference, type: :model do
    it { 
        should belong_to(:user) 
        should belong_to(:metashift)
    }
    # before :each do 
    #     @unit = double("Cloyne")
    #     @member = double("Member", :unit => @unit, :is_ws_manager? => false)
    #     allow(User).to receive(:find_by_id).and_return(@member)
    #     @user_to_whom_curr_pref_form_does_not_belong = double("User to whom the current preference form does not belong", :id => 123, :unit => @unit, :is_ws_manager? => false)

    # end
    # describe "setting new preferences" do
    #     context "when the current user is a member" do
    #         context "and no preferences have been set" do
    #             it "should show the empty new preference form" do
    #                 expect(assigns(:new)).to eq(true)
    #             end
    #             it "should redirect to the user profile page" do
    #                 post :set_pref_and_avail
    #                 expect(flash[:info]).to be_present
    #                 expect(response).to redirect_to(user_profile_path)
    #             end
    #         end
    #         context "and preferences have already been set" do
    #             it "should redirect to the user profile page" do
    #                 post :edit_prev_and_avail
    #                 expect(flash[:info]).to be_present
    #                 expect(response).to redirect_to(user_profile_path)
    #             end
    #         end
    #     end
        # context "when the preference form does not belong to the current user" do
        #     context "and no preferences have been set" do
        #         it "should show the empty preference form and with the id of this user" do
        #             #lalala
        #         end
        #         it "should redirect to the user profile page of this user" do
        #             #lalala
        #         end
        #     end
        #     context "and preferences have already been set" do
        #         it "should redirect to the user profile page of this user" do
        #             #lalala
        #         end
        #     end
        # end 
    # end
    
    # describe "editing preferences" do
    #     context "when the current user is a member" do
    #         context "and no preferences have been set" do
    #             it "should redirect to the user profile page" do
    #                 post :set_pref_and_avail
    #                 expect(flash[:info]).to be_present
    #                 expect(response).to redirect_to(user_profile_path)
    #             end
    #         end
    #         context "and preferences have already been set" do
    #             it "should show the saved preference form" do
    #                 expect(assigns(:new)).to eq(false)
    #             end
    #             it "should redirect to the user profile page" do
    #                 post :edit_prev_and_avail
    #                 expect(flash[:info]).to be_present
    #                 expect(response).to redirect_to(user_profile_path)
    #             end
    #         end
    #     end
        # context "when the preference form does not belong to the current user" do
        #     context "and no preferences have been set" do
        #         it "should show the empty preference form and with the id of this user" do
        #             #lalala
        #         end
        #         it "should redirect to the user profile page of this user" do
        #             #lalala
        #         end
        #     end
        #     context "and preferences have already been set" do
        #         it "should redirect to the user profile page of this user" do
        #             #lalala
        #         end
        #     end
        # end 
    # end
end
