class Unit < ActiveRecord::Base
    has_one :policy
    has_many :users
    has_many :metashifts
    
    def get_all_metashift_categories
      categories = []
      self.metashifts.all.each do |metashift|
        if not categories.include?(metashift.category)
          categories << metashift.category
        end
      end
      categories
    end
end
