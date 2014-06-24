Feature: Set feature flags with rake tasks
  As a Site Admin
  So that I can smoothly deploy new features
  I want to enable features that have been hidden by developers, one by one

  As a developer
  So that I can test thoroughly
  I want to enable all the hidden features

  Scenario: Clear a feature flag
    PENDING
    # When I turn off the "foo" feature flag with rake
    # Then I turn on the "bar" feature flag with rake
    # Then the "foo" flag is disabled

  Scenario: Set a feature flag
    PENDING
    # When I turn on the "foo" feature flag with rake
    # Then the "foo" flag is enabled

  Scenario: Turn on all feature flags
    Given there is a list of feature flags in a text file
    When I turn on all the feature flags with a command
    Then all the feature flags are enabled
    Then delete temporary file