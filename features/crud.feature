Feature: CRUD via Neo4j

  Scenario: Add a new IP Address
    When I create a new IP address
    Then that IP address should exist in the Neo4j database