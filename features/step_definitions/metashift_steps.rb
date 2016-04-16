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
    # sweep_kitchen = Metashift.create!(:category => 'Kitchen', :name => 'Sweep Floors', :multiplier => 1, :description => 'Sweeping the kitchen floors')
    # clean_shower = Metashift.create!(:category => 'Bathroom', :name => 'Clean the shower', :multiplier => 1.5, :description => 'Cleaning the upstairs bathroom')
    # sweep_shift = sweep_kitchen.create_shift!(:start_time => '01:00PM', :end_time => '03:00PM', :day_of_week => 'Wednesday')
    # clean_shower.create_shift!(:start_time => '02:30PM', :end_time => '03:30PM', :day_of_week => 'Friday')
    user_maura.shifts << [kitchen_shift, shower_shift]
end

And /^some workshifts have been created for the semester$/ do
    step "I have created workshifts for the semester"
end



Given(/^none of the workshifts exists$/) do
  Metashifts.agents.destroy_all
end

