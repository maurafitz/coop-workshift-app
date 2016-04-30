Given /^the following metashifts exist:$/ do |metashifts_table|
  metashifts_table.hashes.each do |metashift|
    m = Metashift.create!(metashift)
    m.unit = @current_unit
    puts @current_unit
    m.save
  end
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
