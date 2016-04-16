Given /^the following metashifts exist:$/ do |metashifts_table|
  metashifts_table.hashes.each do |metashift|
    m = Metashift.create!(metashift)
    m.unit = @current_unit
    m.save
  end
end

Given(/^the following workshifts exist:$/) do |metashifts_table|
  metashifts_table.hashes.each do |metashift|
    Metashift.create!(metashift)
  end
end

And /^I have created workshifts for the semester$/ do
    user_maura = User.create!(first_name: "Maura", last_name: "Fitz", email: "momo@berkeley.edu", password: "pw")
    sweep_kitchen = Metashift.create!(category: "Kitchen", description: 'Sweeping the kitchen floors', multiplier: 1)
    clean_shower = Metashift.create!(category: 'Bathroom', description: 'Cleaning the upstairs bathroom', multiplier: 1.5)
    kitchen_shift = Shift.create!(start_time: "2:00PM", end_time: "4:00PM", metashift_id: sweep_kitchen.id)
    shower_shift = Shift.create!(start_time: "11:00AM", end_time: "12:00PM", metashift_id: clean_shower.id)
    user_maura.shifts << [kitchen_shift, shower_shift]
end

And /^some workshifts have been created for the semester$/ do
    step "I have created workshifts for the semester"
end

Given(/^none of the workshifts exists$/) do
  Metashifts.agents.destroy_all
end


And /^"(.+)" should have day "(.+") with hours "(\d\d:\d\d[AP]M)" to "(\d\d:\d\d[AP]M)"$/ do |task, day, startTime, endTime|
     row = find('tr', text: task)
     # Note: the expected content depends on if we create the specific datetime objects for that week, or
     # leave in a more abstract format, like Wednesday, 3:00PM to 4:00PM
     row.should have_content(startTime)
     row.should have_content(endTime)
     row.should have_content(day)
     row.should have_content(category)
 end
 
  And /^"(.+)" should have category "(.+)" with hour value "(\d)"$/ do |task, category, hourValue|
     row = find('tr', text: task)
     row.should have_content(category)
     row.should have_content(hourValue)
 end

And /^I follow edit for "(.*)"$/ do |text|
    within :xpath, "//table//tr[td[contains(.,\"#{text}\")]]" do
        click_link 'Edit'
    end
end
