module Bunto
  module Commands
    class Build < Command
      class << self
        # Create the Mercenary command for the Bunto CLI for this Command
        def init_with_program(prog)
          prog.command(:build) do |c|
            c.syntax      "build [options]"
            c.description "Build your site"
            c.alias :b

            add_build_options(c)

            c.action do |_, options|
              options["serving"] = false
              Bunto::Commands::Build.process(options)
            end
          end
        end

        # Build your bunto site
        # Continuously watch if `watch` is set to true in the config.
        def process(options)
          # Adjust verbosity quickly
          Bunto.logger.adjust_verbosity(options)

          options = configuration_from_options(options)
          site = Bunto::Site.new(options)

          if options.fetch("skip_initial_build", false)
            Bunto.logger.warn "Build Warning:", "Skipping the initial build." \
                        " This may result in an out-of-date site."
          else
            build(site, options)
          end

          if options.fetch("detach", false)
            Bunto.logger.info "Auto-regeneration:",
              "disabled when running server detached."
          elsif options.fetch("watch", false)
            watch(site, options)
          else
            Bunto.logger.info "Auto-regeneration:", "disabled. Use --watch to enable."
          end
        end

        # Build your Bunto site.
        #
        # site - the Bunto::Site instance to build
        # options - A Hash of options passed to the command
        #
        # Returns nothing.
        def build(site, options)
          t = Time.now
          source      = options["source"]
          destination = options["destination"]
          incremental = options["incremental"]
          Bunto.logger.info "Source:", source
          Bunto.logger.info "Destination:", destination
          Bunto.logger.info "Incremental build:",
            (incremental ? "enabled" : "disabled. Enable with --incremental")
          Bunto.logger.info "Generating..."
          process_site(site)
          Bunto.logger.info "", "done in #{(Time.now - t).round(3)} seconds."
        end

        # Private: Watch for file changes and rebuild the site.
        #
        # site - A Bunto::Site instance
        # options - A Hash of options passed to the command
        #
        # Returns nothing.
        def watch(site, options)
          External.require_with_graceful_fail "bunto-watch"
          watch_method = Bunto::Watcher.method(:watch)
          if watch_method.parameters.size == 1
            watch_method.call(options)
          else
            watch_method.call(options, site)
          end
        end
      end # end of class << self
    end
  end
end
