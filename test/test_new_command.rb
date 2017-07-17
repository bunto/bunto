require "helper"
require "bunto/commands/new"

class TestNewCommand < BuntoUnitTest
  def dir_contents(path)
    Dir["#{path}/**/*"].each do |file|
      file.gsub! path, ""
    end
  end

  def site_template
    File.expand_path("../lib/site_template", File.dirname(__FILE__))
  end

  context "when args contains a path" do
    setup do
      @path = "new-site"
      @args = [@path]
      @full_path = File.expand_path(@path, Dir.pwd)
    end

    teardown do
      FileUtils.rm_r @full_path
    end

    should "create a new directory" do
      refute_exist @full_path
      capture_output { Bunto::Commands::New.process(@args) }
      assert_exist @full_path
    end

    should "create a Gemfile" do
      gemfile = File.join(@full_path, "Gemfile")
      refute_exist @full_path
      capture_output { Bunto::Commands::New.process(@args) }
      assert_exist gemfile
      assert_match(%r!gem "bunto", "#{Bunto::VERSION}"!, File.read(gemfile))
      assert_match(%r!gem "github-pages"!, File.read(gemfile))
    end

    should "display a success message" do
      Bunto::Commands::New.process(@args)
      output = Bunto.logger.messages
      success_message = "New bunto site installed in #{@full_path.cyan}. "
      bundle_message = "Running bundle install in #{@full_path.cyan}... "
      assert_includes output, success_message
      assert_includes output, bundle_message
    end

    should "copy the static files in site template to the new directory" do
      static_template_files = dir_contents(site_template).reject do |f|
        File.extname(f) == ".erb"
      end
      static_template_files << "/Gemfile"

      capture_output { Bunto::Commands::New.process(@args) }

      new_site_files = dir_contents(@full_path).reject do |f|
        File.extname(f) == ".markdown"
      end

      assert_same_elements static_template_files, new_site_files
    end

    should "process any ERB files" do
      erb_template_files = dir_contents(site_template).select do |f|
        File.extname(f) == ".erb"
      end

      stubbed_date = "2013-01-01"
      allow_any_instance_of(Time).to receive(:strftime) { stubbed_date }

      erb_template_files.each do |f|
        f.chomp! ".erb"
        f.gsub! "0000-00-00", stubbed_date
      end

      capture_output { Bunto::Commands::New.process(@args) }

      new_site_files = dir_contents(@full_path).select do |f|
        erb_template_files.include? f
      end

      assert_same_elements erb_template_files, new_site_files
    end

    should "create blank project" do
      blank_contents = %w(/_drafts /_layouts /_posts /index.html)
      capture_output { Bunto::Commands::New.process(@args, "--blank") }
      output = Bunto.logger.messages.last
      bundle_message = "Running bundle install in #{@full_path.cyan}..."
      assert_same_elements blank_contents, dir_contents(@full_path)
      refute_includes output, bundle_message
    end

    should "force created folder" do
      capture_output { Bunto::Commands::New.process(@args) }
      output = capture_output { Bunto::Commands::New.process(@args, "--force") }
      assert_match(%r!New bunto site installed in!, output)
    end

    should "skip bundle install when opted to" do
      capture_output { Bunto::Commands::New.process(@args, "--skip-bundle") }
      output = Bunto.logger.messages.last
      bundle_message = "Bundle install skipped."
      assert_includes output, bundle_message
    end
  end

  context "when multiple args are given" do
    setup do
      @site_name_with_spaces = "new site name"
      @multiple_args = @site_name_with_spaces.split
    end

    teardown do
      FileUtils.rm_r File.expand_path(@site_name_with_spaces, Dir.pwd)
    end

    should "create a new directory" do
      refute_exist @site_name_with_spaces
      capture_output { Bunto::Commands::New.process(@multiple_args) }
      assert_exist @site_name_with_spaces
    end
  end

  context "when no args are given" do
    setup do
      @empty_args = []
    end

    should "raise an ArgumentError" do
      exception = assert_raises ArgumentError do
        Bunto::Commands::New.process(@empty_args)
      end
      assert_equal "You must specify a path.", exception.message
    end
  end
end
