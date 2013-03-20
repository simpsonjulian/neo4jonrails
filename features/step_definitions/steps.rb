IP_ADDRESS = '172.27.1.100'
When /^I create a new IP address$/ do
  visit('/')
  click_link 'New Internet address'
  fill_in 'Number', :with => IP_ADDRESS
  click_button 'Create Internet address'
  #noinspection RubyResolve
  page.has_content? 'Internet address was successfully created'
end

Then /^that IP address should exist in the Neo4j database$/ do
  InternetAddress.find_by_octets(IP_ADDRESS).number.should == IP_ADDRESS
end

Then /^that IP address should not exist in the Neo4j database$/ do
  InternetAddress.find_by_octets(IP_ADDRESS).number.should_not == IP_ADDRESS
end

Given /^there is an IP address in the database$/ do
  InternetAddress.new('10.0.0.1').save
end

Given /^I visit the API to list IP address$/ do
  visit('/internet_addresses.json')
end

Then /^I should see that there is a database there$/ do
  page.has_content?('foobat')
end

When /^the response should be valid JSON$/ do
  lambda {
    JSON.parse(page.html).should_not raise_exception
  }
end

When /^it should not leak neography stuff$/ do
  page.html.should_not match /neography/
end

When /^I delete an IP address$/ do
  visit('/')
  click_link 'Destroy'
  click_link 'OK'
  page.has_content? 'Internet address was successfully created'
end