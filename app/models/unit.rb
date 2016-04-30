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
    
    def get_metashifts_by_category
      self.metashifts.group_by {|metashift| metashift.category}
    end
    
    def get_metashift_workshifts
      @metashift_rows = {}
      self.metashifts.each do |metashift|
        puts metashift
        puts metashift.workshifts
        @metashift_rows[metashift] = metashift.workshifts.group_by {|ws| ws.day}
      end
      @metashift_rows
    end
end
