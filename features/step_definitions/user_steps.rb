### EXISTENCE OF USERS ###
Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /none of the uploaders exists/ do
  User.delete_all(["email in (?)", ["ericn@berkeley.edu","gwillits@berkeley.edu",	"yannie.yip@berkeley.edu", 	"ryan.riddle@berkeley.edu"]])
end

Given /^I am the following user:$/ do |user_table|
  user_table.hashes.each do |user|
    @current_user = User.create!(user)
  end
end

### LOGGING IN USERS ###
def simulate_login(user)
  visit path_to('the home page')
  click_link('Login')
  fill_in('email', :with => user.email)
  fill_in('password', :with => user.password)
  click_button("Sign In")
  @current_user = user
end

Given /^I am logged in as an admin$/ do
  admin_user = User.create!({"first_name"=>"Example", "last_name"=>"Admin", "email"=>"coop_admin@berkeley.edu", "password"=>"admin", "permissions"=>"2"})
  simulate_login(admin_user)
end

Given /^I am logged in as a non-admin$/ do
  regular_user = User.create!({"first_name"=>"Example", "last_name"=>"Non-Admin", "email"=>"non_admin@berkeley.edu", "password"=>"nonadmin", "permissions"=>"0"})
  simulate_login(regular_user)
end

Given /^I am logged in as a workshift manager$/ do
    step "I am logged in as an admin"
end

Given /^I am logged in as a user$/ do
  step "I am logged in as a non-admin"
end

Given(/^I am logged in as a member$/) do
  step "I am logged in as a non-admin" 
end

Given /^I am logged in$/ do
  if not @current_user
    @current_user = User.create!({"first_name"=>"Example", "last_name"=>"Non-Admin", "email"=>"non_admin@berkeley.edu", "password"=>"nonadmin", "permissions"=>"0"})
  end
  simulate_login(@current_user)
end

Given /^"(.*)" is logged in$/ do |first_name|
  pending
  user = @all_users[first_name]
  simulate_login(user)
end

Given /^I am not logged in$/ do
  @current_user = nil
  @current_unit = nil
end

And /^I should not be logged in$/ do
  step %Q{I should not see the following: "Profile", "Sign Out"}
end

### USER ASSOCIATIONS ### 
And /^I belong to "(.*)"$/ do |coop_unit|
  @current_unit = Unit.create!(:name => coop_unit)
  @current_user.unit = @current_unit
  @current_user.save
end

And /^I am a member of "(.*)"$/ do |house|
  step %Q{I belong to "#{house}"}
end

Given(/^I am assigned the following shifts:$/) do |shifts_table|
  shifts_table.hashes.each do |shift|
    metashift_id = shift[:metashift_id]
    shift.delete(:metashift_id)
    shift = @current_user.shifts.create!(shift)
    shift.metashift = Metashift.find(metashift_id)
    shift.save
  end
end

Given(/^"([^"]*)" is assigned the following shifts:$/) do |first_name, shifts_table|
  user = User.find_by_first_name(first_name)
  shifts_table.hashes.each do |shift|
    metashift_id = shift[:metashift_id]
    shift.delete(:metashift_id)
    shift = user.shifts.create!(shift)
    shift.metashift = Metashift.find(metashift_id)
    shift.save
  end
end

### USER ACCESS ### 
Then /^I should have admin rights$/ do
  pending # Write code here that turns the phrase above into concrete actions
end

