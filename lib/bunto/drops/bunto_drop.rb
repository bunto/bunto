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
    end
  end
end
