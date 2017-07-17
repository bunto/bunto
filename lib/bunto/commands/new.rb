require "erb"

module Bunto
  module Commands
    class New < Command
      class << self
        def init_with_program(prog)
          prog.command(:new) do |c|
            c.syntax "new PATH"
            c.description "Creates a new Bunto site scaffold in PATH"

            c.option "force", "--force", "Force creation even if PATH already exists"
            c.option "blank", "--blank", "Creates scaffolding but with empty files"
            c.option "skip-bundle", "--skip-bundle", "Skip 'bundle install'"

            c.action do |args, options|
              Bunto::Commands::New.process(args, options)
            end
          end
        end

        def process(args, options = {})
          raise ArgumentError, "You must specify a path." if args.empty?

          new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_blog_path
          if preserve_source_location?(new_blog_path, options)
            Bunto.logger.abort_with "Conflict:",
                      "#{new_blog_path} exists and is not empty."
          end

          if options["blank"]
            create_blank_site new_blog_path
          else
            create_site new_blog_path
          end

          after_install(new_blog_path, options)
        end

        def create_blank_site(path)
          Dir.chdir(path) do
            FileUtils.mkdir(%w(_layouts _posts _drafts))
            FileUtils.touch("index.html")
          end
        end

        def scaffold_post_content
          ERB.new(File.read(File.expand_path(scaffold_path, site_template))).result
        end

        # Internal: Gets the filename of the sample post to be created
        #
        # Returns the filename of the sample post, as a String
        def initialized_post_name
          "_posts/#{Time.now.strftime("%Y-%m-%d")}-welcome-to-bunto.markdown"
        end

        private

        def gemfile_contents
          <<-RUBY
source "https://rubygems.org"
ruby RUBY_VERSION

# Hello! This is where you manage which Bunto version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Bunto with `bundle exec`, like so:
#
#     bundle exec bunto serve
#
# This will help ensure the proper Bunto version is running.
# Happy Buntoing!
gem "bunto", "#{Bunto::VERSION}"

# This is the default theme for new Bunto sites. You may change this to anything you like.
gem "minima", "~> 2.0"

# If you want to use GitHub Pages, remove the "gem "bunto"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :bunto_plugins

# If you have any plugins, put them here!
group :bunto_plugins do
   gem "bunto-feed", "~> 0.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

RUBY
        end

        def create_site(new_blog_path)
          create_sample_files new_blog_path

          File.open(File.expand_path(initialized_post_name, new_blog_path), "w") do |f|
            f.write(scaffold_post_content)
          end

          File.open(File.expand_path("Gemfile", new_blog_path), "w") do |f|
            f.write(gemfile_contents)
          end
        end

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def create_sample_files(path)
          FileUtils.cp_r site_template + "/.", path
          FileUtils.rm File.expand_path(scaffold_path, path)
        end

        def site_template
          File.expand_path("../../site_template", File.dirname(__FILE__))
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-bunto.markdown.erb"
        end

        # After a new blog has been created, print a success notification and
        # then automatically execute bundle install from within the new blog dir
        # unless the user opts to generate a blank blog or skip 'bundle install'.

        def after_install(path, options = {})
          unless options["blank"] || options["skip-bundle"]
            bundle_install path
          end

          Bunto.logger.info "New bunto site installed in #{path.cyan}."
          Bunto.logger.info "Bundle install skipped." if options["skip-bundle"]
        end

        def bundle_install(path)
          Bunto::External.require_with_graceful_fail "bundler"
          Bunto.logger.info "Running bundle install in #{path.cyan}..."
          Dir.chdir(path) do
            process, output = Bunto::Utils::Exec.run("bundle", "install")
            output.to_s.each_line do |line|
              Bunto.logger.info("Bundler:".green, line.strip) unless line.to_s.empty?
            end
            raise SystemExit unless process.success?
          end
        end
      end
    end
  end
end
