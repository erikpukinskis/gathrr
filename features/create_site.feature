Feature: Creating Sites
  As a user
  I want to be able to create a site with some feeds
  So that other people can easily follow them all

  Scenario: With valid feeds
    When I am on the homepage
      And I fill in "url" with "sumwit"
      And I fill in "feeds" with "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss"
      And I press "Bunch 'em"
    Then I should see "Bunchup is going to be so much fun!"
      And I should see "tail end"
