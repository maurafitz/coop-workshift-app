Given /I fill in my availability correctly/ do
    pending
end

Then /^the "(.*)" category should (not )? be collapsed$/ do |category, not_collapsed|
  category = value.gsub(/ /, '_')
  element = find_by_id('#{category}')
  expect(element).to have_css('.collapse .in')
end

And /^"([^\"]+)" should be hidden test$/ do |text|
  puts page.all('.table', :visible => true).length
  puts page.all('.table', :visible => false).length
  puts page.all('.table', :visible => :hidden).length
end


When(/^I fill in "([^"]*)" for the rank box for "([^"]*)"$/) do |rank, workshift|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^my preferences should be saved$/) do
  pending # Write code here that turns the phrase above into concrete actions
end