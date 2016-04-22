class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :metashift
  
  DEFAULT_RANK = 3
  
  DAY_MAPPING = {
    0=> "Monday",
    1=> "Tuesday",
    2=> "Wednesday",
    3=> "Thursday",
    4=> "Friday",
    5=> "Saturday",
    6=> "Sunday"
  }
  
  def self.day_mapping
    DAY_MAPPING
  end
  
  def set_ratings cat_rank, ms_rank
    self.rating = ms_rank
    self.cat_rating = cat_rank
  end
  
  def get_rating
    if self.rating != 0
      self.rating
    elsif self.cat_rating != 0
      self.cat_rating
    else
      DEFAULT_RANK
    end
  end
end
