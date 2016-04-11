class Unit < ActiveRecord::Base
    has_one :policy
    has_many :users
    has_many :metashifts
end
