Feature: CRUD via Neo4j

  Background:
    Given there is an IP address in the database

  Scenario: Add a new IP Address
    When I create a new IP address
    Then that IP address should exist in the Neo4j database

  Scenario: Delete an IP address
    When I delete an IP address
    Then that IP address should not exist in the Neo4j database