$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

# stdlib
require 'fileutils'
require 'time'
require 'English'
require 'pathname'
require 'logger'
require 'set'

# 3rd party
require 'safe_yaml/load'
require 'liquid'
require 'kramdown'
require 'colorator'

SafeYAML::OPTIONS[:suppress_warnings] = true
Liquid::Template.error_mode = :strict

module Bunto

  # internal requires
  autoload :Cleaner,             'bunto/cleaner'
  autoload :Collection,          'bunto/collection'
  autoload :Configuration,       'bunto/configuration'
  autoload :Convertible,         'bunto/convertible'
  autoload :Deprecator,          'bunto/deprecator'
  autoload :Document,            'bunto/document'
  autoload :Draft,               'bunto/draft'
  autoload :EntryFilter,         'bunto/entry_filter'
  autoload :Errors,              'bunto/errors'
  autoload :Excerpt,             'bunto/excerpt'
  autoload :External,            'bunto/external'
  autoload :Filters,             'bunto/filters'
  autoload :FrontmatterDefaults, 'bunto/frontmatter_defaults'
  autoload :Layout,              'bunto/layout'
  autoload :CollectionReader,    'bunto/readers/collection_reader'
  autoload :DataReader,          'bunto/readers/data_reader'
  autoload :LayoutReader,        'bunto/readers/layout_reader'
  autoload :DraftReader,         'bunto/readers/draft_reader'
  autoload :PostReader,          'bunto/readers/post_reader'
  autoload :PageReader,          'bunto/readers/page_reader'
  autoload :StaticFileReader,    'bunto/readers/static_file_reader'
  autoload :LogAdapter,          'bunto/log_adapter'
  autoload :Page,                'bunto/page'
  autoload :PluginManager,       'bunto/plugin_manager'
  autoload :Post,                'bunto/post'
  autoload :Publisher,           'bunto/publisher'
  autoload :Reader,              'bunto/reader'
  autoload :Regenerator,         'bunto/regenerator'
  autoload :RelatedPosts,        'bunto/related_posts'
  autoload :Renderer,            'bunto/renderer'
  autoload :Site,                'bunto/site'
  autoload :StaticFile,          'bunto/static_file'
  autoload :Stevenson,           'bunto/stevenson'
  autoload :URL,                 'bunto/url'
  autoload :Utils,               'bunto/utils'
  autoload :VERSION,             'bunto/version'

  # extensions
  require 'bunto/plugin'
  require 'bunto/converter'
  require 'bunto/generator'
  require 'bunto/command'
  require 'bunto/liquid_extensions'

  class << self
    # Public: Tells you which Bunto environment you are building in so you can skip tasks
    # if you need to.  This is useful when doing expensive compression tasks on css and
    # images and allows you to skip that when working in development.

    def env
      ENV["BUNTO_ENV"] || "development"
    end

    # Public: Generate a Bunto configuration Hash by merging the default
    # options with anything in _config.yml, and adding the given options on top.
    #
    # override - A Hash of config directives that override any options in both
    #            the defaults and the config file. See Bunto::Configuration::DEFAULTS for a
    #            list of option names and their defaults.
    #
    # Returns the final configuration Hash.
    def configuration(override = Hash.new)
      config = Configuration[Configuration::DEFAULTS]
      override = Configuration[override].stringify_keys
      unless override.delete('skip_config_files')
        config = config.read_config_files(config.config_files(override))
      end

      # Merge DEFAULTS < _config.yml < override
      config = Utils.deep_merge_hashes(config, override).stringify_keys
      set_timezone(config['timezone']) if config['timezone']

      config
    end

    # Public: Set the TZ environment variable to use the timezone specified
    #
    # timezone - the IANA Time Zone
    #
    # Returns nothing
    def set_timezone(timezone)
      ENV['TZ'] = timezone
    end

    # Public: Fetch the logger instance for this Bunto process.
    #
    # Returns the LogAdapter instance.
    def logger
      @logger ||= LogAdapter.new(Stevenson.new, (ENV["BUNTO_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: Set the log writer.
    #         New log writer must respond to the same methods
    #         as Ruby's interal Logger.
    #
    # writer - the new Logger-compatible log transport
    #
    # Returns the new logger.
    def logger=(writer)
      @logger = LogAdapter.new(writer)
    end

    # Public: An array of sites
    #
    # Returns the Bunto sites created.
    def sites
      @sites ||= []
    end

    # Public: Ensures the questionable path is prefixed with the base directory
    #         and prepends the questionable path with the base directory if false.
    #
    # base_directory - the directory with which to prefix the questionable path
    # questionable_path - the path we're unsure about, and want prefixed
    #
    # Returns the sanitized path.
    def sanitized_path(base_directory, questionable_path)
      return base_directory if base_directory.eql?(questionable_path)

      clean_path = File.expand_path(questionable_path, "/")
      clean_path = clean_path.sub(/\A\w\:\//, '/')

      unless clean_path.start_with?(base_directory.sub(/\A\w\:\//, '/'))
        File.join(base_directory, clean_path)
      else
        clean_path
      end
    end

    # Conditional optimizations
    Bunto::External.require_if_present('liquid-c')

  end
end

require_all 'bunto/commands'
require_all 'bunto/converters'
require_all 'bunto/converters/markdown'
require_all 'bunto/generators'
require_all 'bunto/tags'

require 'bunto-sass-converter'
