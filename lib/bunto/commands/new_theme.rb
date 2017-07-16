require "erb"

class Bunto::Commands::NewTheme < Bunto::Command
  class << self
    def init_with_program(prog)
      prog.command(:"new-theme") do |c|
        c.syntax "new-theme NAME"
        c.description "Creates a new Bunto theme scaffold"
        c.option "code_of_conduct", \
          "-c", "--code-of-conduct", \
          "Include a Code of Conduct. (defaults to false)"

        c.action do |args, opts|
          Bunto::Commands::NewTheme.process(args, opts)
        end
      end
    end

    # rubocop:disable Metrics/AbcSize
    def process(args, opts)
      if !args || args.empty?
        raise Bunto::Errors::InvalidThemeName, "You must specify a theme name."
      end

      new_theme_name = args.join("_")
      theme = Bunto::ThemeBuilder.new(new_theme_name, opts)
      if theme.path.exist?
        Bunto.logger.abort_with "Conflict:", "#{theme.path} already exists."
      end

      theme.create!
      Bunto.logger.info "Your new Bunto theme, #{theme.name.cyan}," \
        " is ready for you in #{theme.path.to_s.cyan}!"
      Bunto.logger.info "For help getting started, read #{theme.path}/README.md."
    end
    # rubocop:enable Metrics/AbcSize
  end
end
