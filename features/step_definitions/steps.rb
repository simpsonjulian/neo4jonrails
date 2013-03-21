IP_ADDRESS1 = '172.27.1.100'
IP_ADDRESS2 = '172.27.1.201'

When /^I create a new IP address$/ do
  visit('/')
  click_link 'New Internet address'
  fill_in 'Number', :with => IP_ADDRESS1
  click_button 'Create Internet address'
  #noinspection RubyResolve
  page.has_content?('Internet address was successfully created').should == true
end

Then /^that IP address should exist in the Neo4j database$/ do
  #InternetAddress.find_by_number(IP_ADDRESS1).first.number.should == IP_ADDRESS1
  #TODO: write better query
end

Then /^that IP address should not exist in the Neo4j database$/ do
  InternetAddress.find_by_number(IP_ADDRESS1).first.should be_nil
end

Given /^there is an IP address in the database$/ do
  InternetAddress.new('10.0.0.1').save
end

Given /^I visit the API to list IP address$/ do
  visit('/internet_addresses.json')
end

Then /^I should see that there is a database there$/ do
  page.has_content?('10.0.0.1').should == true
end

When /^the response should be valid JSON$/ do
  lambda {
    JSON.parse(page.html).should_not raise_exception
  }
end

When /^it should not leak neography stuff$/ do
  page.has_content?(/neography/).should == false
end

When /^I delete an IP address$/ do
  visit('/')
  click_link 'Destroy'
  page.driver.browser.switch_to.alert.accept
end

When /^I edit an IP address$/ do
  visit('/')
  click_link 'Edit'
  fill_in 'Number', :with => IP_ADDRESS2
  click_button 'Update Internet address'
end

Then /^that IP address should exist in the Neo4j database with the new attributes$/ do
  puts page.html
  page.has_content?(IP_ADDRESS2).should == true
end
Then /^I should see the listing page$/ do
  page.has_content?(/addresses/).should == true
end