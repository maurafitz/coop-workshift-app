class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :metashift
  
  DEFAULT_RANK = 3
  
  def set_rankings cat_rank, ms_rank
    if cat_rank != 0 and ms_rank == 0
      self.rating = cat_rating
    else
      self.rating = ms_rank
    end
    self.cat_rating = cat_rank
  end
  
  def get_ranking
    if self.ranking != 0
      self.ranking
    else
      DEFAULT_RANK
    end
  end
  
  def get_raw_ranking
    
  end
end
