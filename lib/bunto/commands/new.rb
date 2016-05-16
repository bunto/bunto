require 'erb'

module Bunto
  module Commands
    class New < Command
      class << self
        def init_with_program(prog)
          prog.command(:new) do |c|
            c.syntax 'new PATH'
            c.description 'Creates a new Bunto site scaffold in PATH'

            c.option 'force', '--force', 'Force creation even if PATH already exists'
            c.option 'blank', '--blank', 'Creates scaffolding but with empty files'

            c.action do |args, options|
              Bunto::Commands::New.process(args, options)
            end
          end
        end

        def process(args, options = {})
          raise ArgumentError.new('You must specify a path.') if args.empty?

          new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_blog_path
          if preserve_source_location?(new_blog_path, options)
            Bunto.logger.abort_with "Conflict:", "#{new_blog_path} exists and is not empty."
          end

          if options["blank"]
            create_blank_site new_blog_path
          else
            create_sample_files new_blog_path

            File.open(File.expand_path(initialized_post_name, new_blog_path), "w") do |f|
              f.write(scaffold_post_content)
            end

            File.open(File.expand_path("Gemfile", new_blog_path), "w") do |f|
              f.write(gemfile_contents)
            end
          end

          Bunto.logger.info "New bunto site installed in #{new_blog_path}."
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
          "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-bunto.markdown"
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

# If you want to use GitHub Pages, remove the "gem "bunto"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :bunto_plugins

# If you have any plugins, put them here!
# group :bunto_plugins do
#   gem "bunto-github-metadata", "~> 1.0"
# end
RUBY
        end

        def preserve_source_location?(path, options)
          !options["force"] && !Dir["#{path}/**/*"].empty?
        end

        def create_sample_files(path)
          FileUtils.cp_r site_template + '/.', path
          FileUtils.rm File.expand_path(scaffold_path, path)
        end

        def site_template
          File.expand_path("../../site_template", File.dirname(__FILE__))
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-bunto.markdown.erb"
        end
      end
    end
  end
end
