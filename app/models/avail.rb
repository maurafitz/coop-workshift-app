class Avail < ActiveRecord::Base
  belongs_to :user
  
  def self.get_availability_mapping list_of_availabilities
    # Returns a dictionary that maps "day,hour" => "status"
    @availability_mapping = {}
    list_of_availabilities.each do |availability| 
      @availability_mapping[availability.day.to_s + "," + availability.hour.to_s] = availability.status
    end
    @availability_mapping
  end
end
