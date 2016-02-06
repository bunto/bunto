module Bunto
  module Commands
    class Clean < Command
      class << self
        def init_with_program(prog)
          prog.command(:clean) do |c|
            c.syntax 'clean [subcommand]'
            c.description 'Clean the site (removes site output and metadata file) without building.'

            add_build_options(c)

            c.action do |_, options|
              Bunto::Commands::Clean.process(options)
            end
          end
        end

        def process(options)
          options = configuration_from_options(options)
          destination = options['destination']
          metadata_file = File.join(options['source'], '.bunto-metadata')

          if File.directory? destination
            Bunto.logger.info "Cleaning #{destination}..."
            FileUtils.rm_rf(destination)
            Bunto.logger.info "", "done."
          else
            Bunto.logger.info "Nothing to do for #{destination}."
          end

          if File.file? metadata_file
            Bunto.logger.info "Removing #{metadata_file}..."
            FileUtils.rm_rf(metadata_file)
            Bunto.logger.info "", "done."
          else
            Bunto.logger.info "Nothing to do for #{metadata_file}."
          end
        end
      end
    end
  end
end
