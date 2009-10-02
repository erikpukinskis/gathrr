When /^I work through the work queue$/ do
  Delayed::Job.work_off
end

