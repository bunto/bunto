module Bunto
  module Converters
    class Markdown < Converter
      highlighter_prefix "\n"
      highlighter_suffix "\n"
      safe true

      def setup
        return if @setup ||= false
        unless (@parser = get_processor)
          Bunto.logger.error "Invalid Markdown processor given:", @config["markdown"]
          Bunto.logger.info  "", "Custom processors are not loaded in safe mode" if @config["safe"]
          Bunto.logger.error "", "Available processors are: #{valid_processors.join(", ")}"
          raise Errors::FatalException, "Bailing out; invalid Markdown processor."
        end

        @setup = true
      end

      def get_processor
        case @config["markdown"].downcase
        when "redcarpet" then return RedcarpetParser.new(@config)
        when "kramdown"  then return KramdownParser.new(@config)
        when "rdiscount" then return RDiscountParser.new(@config)
        else
          get_custom_processor
        end
      end

      # Public: Provides you with a list of processors, the ones we
      # support internally and the ones that you have provided to us (if you
      # are not in safe mode.)

      def valid_processors
        %W(rdiscount kramdown redcarpet) + third_party_processors
      end

      # Public: A list of processors that you provide via plugins.
      # This is really only available if you are not in safe mode, if you are
      # in safe mode (re: GitHub) then there will be none.

      def third_party_processors
        self.class.constants - \
        %w(KramdownParser RDiscountParser RedcarpetParser PRIORITIES).map(
          &:to_sym
        )
      end

      def extname_list
        @extname_list ||= @config['markdown_ext'].split(',').map do |e|
          ".#{e.downcase}"
        end
      end

      def matches(ext)
        extname_list.include?(ext.downcase)
      end

      def output_ext(_ext)
        ".html"
      end

      def convert(content)
        setup
        @parser.convert(content)
      end

      private
      def get_custom_processor
        converter_name = @config["markdown"]
        if custom_class_allowed?(converter_name)
          self.class.const_get(converter_name).new(@config)
        end
      end

      # Private: Determine whether a class name is an allowed custom
      #   markdown class name.
      #
      # parser_name - the name of the parser class
      #
      # Returns true if the parser name contains only alphanumeric
      # characters and is defined within Bunto::Converters::Markdown

      private
      def custom_class_allowed?(parser_name)
        parser_name !~ /[^A-Za-z0-9_]/ && self.class.constants.include?(
          parser_name.to_sym
        )
      end
    end
  end
end