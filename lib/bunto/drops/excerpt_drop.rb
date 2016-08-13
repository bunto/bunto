# encoding: UTF-8

module Bunto
  module Drops
    class ExcerptDrop < DocumentDrop
      def layout
        @obj.doc.data["layout"]
      end

      def excerpt
        nil
      end
    end
  end
end
