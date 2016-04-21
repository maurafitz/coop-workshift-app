class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :metashift
  
  DEFAULT_RANK = 3
  
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
