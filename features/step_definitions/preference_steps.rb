Given /I fill in my availability correctly/ do
    pending
end

Then /^the "(.*)" category should (not )?be collapsed$/ do |category, not_collapsed|
  category = category.gsub(/ /, '_')
  element = find_by_id(category)
  expect(element[:class]).to include('collapse')
  if not_collapsed
    # puts page.body
    expect(element[:class]).to include('in')
  else
    expect(element[:class]).to_not include('in')
  end
end

When(/^I fill in "([^"]*)" for the rank box for "([^"]*)"$/) do |rank, workshift|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^my preferences should be saved$/) do
  pending # Write code here that turns the phrase above into concrete actions
end