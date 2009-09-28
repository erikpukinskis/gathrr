Feature: Creating Sites
  As a curator
  I want to be able to create a site with some feeds
  So that other people can easily follow them all

  Scenario: With valid feeds
    When I am on the homepage
      And I fill in "url" with "sumwit"
      And I fill in "feeds" with " http://bunchuptest.wordpress.com/feed/ "
      And I press "Bunch 'em"
    Then I should see "surprise ending"
