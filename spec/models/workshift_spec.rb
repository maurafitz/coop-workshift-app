require 'rails_helper'

RSpec.describe Workshift, type: :model do
    it { 
        should belong_to(:user) 
        should have_many(:shifts)
        should belong_to(:metashift)
    }
    # before :each do
        # @workshift = Workshift.new(:start_time => start_time, :end_time => end_time, :day => day, :length => length)
    # end
end
