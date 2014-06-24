When(/^I turn (off|on) the "(.*?)" feature flag with rake$/)  do |action, feature|
  # require "rake"
  # @rake ||= Rake::Application.new
  # Rake.application = @rake
  # Rake.application.rake_require "tasks/feature_flags"
  puts "About to run rake ff['#{feature}',:#{action}]"
  system("RAILS_ENV=test rake ff['#{feature}',:#{action}]")
  # Rake::Task.define_task(:environment)
  # Rake::Task['ff'].invoke(feature, action)
  # Rake::Task['ff'].reenable
  puts 'ran rake'
  puts 'All my features: ', Feature.all
end

Given(/^the (.+) feature is (enabled|disabled)$/) do |feature, state|
  if f = Feature.find_by_name(feature) then
    f.update_attributes(active: (state == 'enabled'))
  else
    Feature.create!(name: feature, active: (state == 'enabled'))
  end
end

Then (/^the (.+) flag is (enabled|disabled)$/) do |feature, state|
  puts 'All my features: ', Feature.all
  puts "Searching for #{feature}, ... found this: #{Feature.find_by_name(feature)}"
  expect(Feature.active?(feature)).to eq(state=='enabled')
end

Given(/^there is a list of feature flags in a text file$/) do
  # Will only work on Unix-like systems with a /tmp directory of
  # throwaway files
  temp_file = File.new("/tmp/cucumber-localsupport-flags", "w")
  temp_file.puts "foo_list"
  temp_file.puts "bar_create"
  temp_file.close
end

When(/^I turn on all the feature flags with a command$/) do
  # simulates 'rails runner enable_all_features'
  # dcorking could not figure out how to send arguments efficiently for testing
  require File.expand_path './script/enable_all_features'
end

Then(/^all the feature flags are enabled$/) do
  expect(Feature.active?(:foo_list)).to be_true
  expect(Feature.active?(:bar_create)).to be_true
end

Then (/^delete temporary file$/) do
  FileUtils.rm "/tmp/cucumber-localsupport-flags"
end
