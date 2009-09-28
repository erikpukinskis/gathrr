Given /^there is a site "([^\"]*)" with feeds "([^\"]*)"$/ do |slug, feed_list|
  Site.create!(:slug => slug, :feed_list => feed_list)
end

