require 'rails_helper'

RSpec.describe SignoffsController, type: :controller do
    describe 'configuring the unit' do
        before(:each) do
            @unit = Unit.create!(:name => 'Castro')
        end
        it 'should successfully save a valid unit' do
            post :set_unit, :unit => @unit.id
            expect(response).to redirect_to('/')
            expect(flash[:success]).to be_present
        end
        it 'should redirect and error if an invalid unit is provided' do
            post :set_unit, :unit => 345
            expect(flash[:danger]).to be_present
            expect(response).to redirect_to(get_unit_path)
        end
    end
end