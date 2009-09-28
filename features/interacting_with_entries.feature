Feature: interacting with entries
  As a reader
  I want to be able to interact with an entry
  So I can get more information on a post

  Scenario: Visiting the bunchup test blog
    Given there is a site "bunchup blogs" with feeds "http://bunchuptest.wordpress.com/feed/"
      And I am on the "bunchup blogs" site
    When I follow "Bunchup Test"
    Then I should see "Bunchup Test"
