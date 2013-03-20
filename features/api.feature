Feature: API
  As an app developer
  I'd like an API
  So I can make a social media mashup and make the front cover of Reddit

  Background:
    Given there is an IP address in the database

  Scenario: list databases via the API
    When I visit the API to list IP address
    Then I should see that there is a database there
    And the response should be valid JSON
    And it should not leak neography stuff