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