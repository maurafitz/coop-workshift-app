class Shift < ActiveRecord::Base
  belongs_to :workshift
  belongs_to :user
  belongs_to :signoff_by, :class_name => "User"
  
  def full_json
    self.as_json(:include=> {:workshift=> {:include=> :metashift}, 
    :user => {}} )
  end
end
