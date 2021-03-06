Feature: Disclaimer about not being able to guarantee accuracy of sites content and notice about being beta site
  As the system owner
  So that I can avoid any liability
  I want to show a link to a disclaimer on every page
  Tracker story ID: https://www.pivotaltracker.com/story/show/49757817

  Background: organizations have been added to database

  Given the following organizations exist:
    | name             | address        |
    | Friendly Charity | 83 pinner road |
  Given the following pages exist:
    | name       | permalink  | content                                                   | link_visible |
    | 404        | 404        | We're sorry, but we couldn't find the page you requested! | false        |
    | Disclaimer | disclaimer | We disclaim everything!                                   | true         |

  Scenario Outline: the disclaimer page is accessible on all pages
    Given I visit the <page>
    When I follow "Disclaimer"
    Then I should see "We disclaim everything!"
  Examples:
    | page                                                    |
    | home page                                               |
    | organisations index page                                |
    | new organisation page                                   |
    | show page for the organization named "Friendly Charity" |

