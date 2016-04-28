Given(/^the following shifts exist:$/) do |shifts|
  pending # Write code here that turns the phrase above into concrete actions
  shifts.hashes.each do |shifts_hash|
    metashift, days, time_blocks = shifts_hash[:metashift], shifts_hash[:days], shifts_hash[:time_blocks]
  end
end

Given(/^I choose the day "(.*)"/) do |day|
  #select '#{day}', from: "workdays"
  find('#weekday_btn').click
  click_on "#{day}"
end

Given(/^I choose the "(.*)" time as "(.*)" "(.*)"/) do |start_or_end, time, am_pm|
  if start_or_end == "start"
    fill_in("start_time", :with => time)
    find('#start_btn').click
    click_on "#{am_pm}"
  elsif start_or_end == "end"
    fill_in("end_time", :with => time)
    find('#end_btn').click
    within("#end_am_pm") do
      click_on "#{am_pm}"
    end
  end
end

Given(/I set the length to be "(.*)"/) do |len|
  fill_in("shift_length", :with => len)
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

Then(/^"([^"]*)" should be assigned the shift "([^"]*)"$/) do |first_name, shift_info|
  pending # need to be able to get shift by day (ex. Monday)
  user = User.find_by_first_name(first_name)
  shift = get_shift shift_info
  expect(shift.user).to be(user)
end

Then(/^no one should be assigned to the shift "([^"]*)"$/) do |shift|
  pending # need to be able to get shift by day (ex. Monday), check what unasigned shift.user is
  shift = get_shift shift_info
  expect(shift.user).to be nil
end

def get_shift shift_info
  pending # need to be able to get shift by day (ex. Monday)
  shift =~ /^(.*), (.*), (.*)-(.*)$/
  shift_name, day, start_time, end_time = $1, $2, $3, $4
  metashift = Metashift.find_by_name(shift_name)
  shift = metashift.shifts.where('start_time = #{start_time} and end_time = #{end_time}')
end