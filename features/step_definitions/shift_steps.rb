Given(/^the following shifts exist:$/) do |shifts|
  pending # Write code here that turns the phrase above into concrete actions
  shifts.hashes.each do |shifts_hash|
    metashift, days, time_blocks = shifts_hash[:metashift], shifts_hash[:days], shifts_hash[:time_blocks]
  end
end

Then(/^([^"]*)'s shift for "([^"]*)" on "([^"]*)" should (not )?be completed$/) do |first_name, metashift_name, date, bool|
  user = User.find_by_first_name(first_name)
  metashift = Metashift.find_by_name(metashift_name)
  date = Date.parse(date)
  user.shifts.each do |shift|
    if shift.metashift == metashift and shift.date == date
      if bool
        assert shift.completed == false
      else
        assert shift.completed == true
      end
    end
  end
end

Then(/^I should see "([^"]*)" shift slots$/) do |count|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I select the shift: "([^"]*)"$/) do |shift_info|
  pending # Write code here that turns the phrase above into concrete actions
end