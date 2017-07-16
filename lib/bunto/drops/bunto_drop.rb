# encoding: UTF-8

module Bunto
  module Drops
    class BuntoDrop < Liquid::Drop
      class << self
        def global
          @global ||= BuntoDrop.new
        end
      end

      def version
        Bunto::VERSION
      end

      def environment
        Bunto.env
      end

      def to_h
        @to_h ||= {
          "version"     => version,
          "environment" => environment,
        }
      end

      def to_json(state = nil)
        require "json"
        JSON.generate(to_h, state)
      end
    end
  end
end
