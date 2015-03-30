Feature: Rendering
  As a hacker who likes to blog
  I want to be able to make a static site
  In order to share my awesome ideas with the interwebs
  But I want to make it as simply as possible
  So render with Liquid and place in Layouts

  Scenario: Render Liquid and place in layout
    Given I have a "index.html" page with layout "simple" that contains "Hi there, Bunto {{ bunto.environment }}!"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run bunto build
    Then the _site directory should exist
    And I should see "Hi there, Bunto development!\nAhoy, indeed" in "_site/index.html"

  Scenario: Don't place asset files in layout
    Given I have an "index.scss" page with layout "simple" that contains ".foo-bar { color:black; }"
    And I have an "index.coffee" page with layout "simple" that contains "whatever()"
    And I have a configuration file with "gems" set to "[bunto-coffeescript]"
    And I have a simple layout that contains "{{ content }}Ahoy, indeed!"
    When I run bunto build
    Then the _site directory should exist
    And I should not see "Ahoy, indeed!" in "_site/index.css"
    And I should not see "Ahoy, indeed!" in "_site/index.js"

  Scenario: Render liquid in Sass
    Given I have an "index.scss" page that contains ".foo-bar { color:{{site.color}}; }"
    And I have a configuration file with "color" set to "red"
    When I run bunto build
    Then the _site directory should exist
    And I should see ".foo-bar {\n  color: red; }" in "_site/index.css"

  Scenario: Not render liquid in CoffeeScript without explicitly including bunto-coffeescript
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    When I run bunto build
    Then the _site directory should exist
    And the "_site/index.js" file should not exist

  Scenario: Render liquid in CoffeeScript with bunto-coffeescript enabled
    Given I have an "index.coffee" page with animal "cicada" that contains "hey='for {{page.animal}}'"
    And I have a configuration file with "gems" set to "[bunto-coffeescript]"
    When I run bunto build
    Then the _site directory should exist
    And I should see "hey = 'for cicada';" in "_site/index.js"
