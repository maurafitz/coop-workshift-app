class AddCategoryRankingToPreference < ActiveRecord::Migration
  def change
    add_column :preferences, :cat_rating, :integer
  end
end
