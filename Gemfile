source "https://rubygems.org"
gemspec :name => "bunto"

gem "rake", "~> 11.0"

# Dependency of bunto-mentions. RubyGems in Ruby 2.1 doesn't shield us from this.
gem "activesupport", "~> 4.2", :groups => [:test_legacy, :site] if RUBY_VERSION < '2.2.2'

group :development do
  gem "launchy", "~> 2.3"
  gem "pry"

  unless RUBY_ENGINE == "jruby"
    gem "pry-byebug"
  end
end

#

group :test do
  gem "rubocop"
  gem "cucumber", "~> 2.1"
  gem "bunto_test_plugin"
  gem "bunto_test_plugin_malicious"
  gem "codeclimate-test-reporter"
  gem "rspec-mocks"
  gem "nokogiri"
  gem "rspec"
  gem "test-theme", path: File.expand_path("./test/fixtures/test-theme", File.dirname(__FILE__))

  gem "jruby-openssl" if RUBY_ENGINE == "jruby"
end

#

group :test_legacy do
  if RUBY_PLATFORM =~ /cygwin/ || RUBY_VERSION.start_with?("2.2")
    gem 'test-unit'
  end

  gem "redgreen"
  gem "simplecov"
  gem "minitest-reporters"
  gem "minitest-profile"
  gem "minitest"
  gem "shoulda"
end

#

group :benchmark do
  if ENV["BENCHMARK"]
    gem "ruby-prof"
    gem "benchmark-ips"
    gem "stackprof"
    gem "rbtrace"
  end
end

#

group :bunto_optional_dependencies do
  gem "toml", "~> 0.1.0"
  gem "coderay", "~> 1.1.0"
  gem "bunto-docs", :path => '../docs' if Dir.exist?('../docs') && ENV['BUNTO_VERSION']
  gem "bunto-gist"
  gem "bunto-feed"
  gem "bunto-coffeescript"
  gem "bunto-redirect-from"
  gem "bunto-paginate"
  gem "mime-types", "~> 3.0"
  gem "kramdown", "~> 1.9"
  gem "rdoc", "~> 4.2"

  platform :ruby, :mswin, :mingw do
    gem "rdiscount", "~> 2.0"
    gem "pygments.rb", "~> 0.6.0"
    gem "redcarpet", "~> 3.2", ">= 3.2.3"
    gem "classifier-reborn", "~> 2.0"
    gem "liquid-c", "~> 3.0"
  end
end

#

group :site do
  if ENV["PROOF"]
    gem "html-proofer", "~> 2.0"
  end

  gem "bemoji", "3.0.0"
  gem "bunto-sitemap"
  gem "bunto-seo-tag"
  gem "bunto-avatar"
  gem "bunto-mentions"
end
