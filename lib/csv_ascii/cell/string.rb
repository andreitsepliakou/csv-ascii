require "./lib/csv_ascii/cell/base"

module CSVASCII
  module Cell
    class String < CSVASCII::Cell::Base
      SEPARATOR = " "

      def initialize(data)
        @data = data&.split(SEPARATOR) || Array("")
      end

      def height
        data.count
      end

      def align
        :left
      end
    end
  end
end
