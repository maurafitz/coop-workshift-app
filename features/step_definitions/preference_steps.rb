def convert_to_id value
    value.gsub(/ /, "_")
end 

Then /^the "(.*)" category should (not )?be collapsed$/ do |category, not_collapsed|
  category = convert_to_id category
  element = find_by_id(category)
  expect(element[:class]).to include('collapse')
  if not_collapsed
    expect(element[:class]).to include('in')
  else
    expect(element[:class]).to_not include('in')
  end
end

Given /^I have not saved any preferences$/ do
  @category_rankings = {}
  @shift_rankings = {}
end

When /^I fill in the following rankings:$/ do |fields|
  categories = @current_unit.get_all_metashift_categories
  fields.rows_hash.each do |name, value|
    if categories.include?(name)
      @category_rankings[name] = value.to_i
      name = "category[#{convert_to_id name}]"
    else
      @shift_rankings[name] = value.to_i
      name = "meta[#{Metashift.find_by_name(name).id}]"
    end
    step %Q{I fill in "#{value}" for "#{name}"}
  end
end

Then(/^my preferences should be saved$/) do
  db_preferences = {}
  @current_user.preferences.each do |preference|
    db_preferences[Metashift.find_by_id(preference.metashift_id)] = preference.rating
  end
  db_preferences.each do |metashift, ranking|
    if @shift_rankings.key?(metashift.name)
      expect(ranking).to eq(@shift_rankings[metashift.name])
    elsif @category_rankings.key?(metashift.category)
      expect(ranking).to eq(@category_rankings[metashift.category])
    else
      expect(ranking).to eq(3)
    end
  end
end
  
Given /I fill in my availability correctly/ do
    pending
end