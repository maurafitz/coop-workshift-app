Given(/I search for and select "(.*)"/) do |full_name|
    pending
    fill_in('member', :with => full_name)
    step %Q{Then I should see "Aziz Ansari"}
    step %Q{When I click on "Aziz Ansari"}
end

Given(/I search for "(.*)"/) do |full_name|
    pending
end