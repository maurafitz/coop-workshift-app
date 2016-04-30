require 'rails_helper'

RSpec.describe Metashift, type: :model do
    it { 
        should belong_to(:unit) 
        should have_many(:preferences)
        should have_many(:workshifts)
    }
end