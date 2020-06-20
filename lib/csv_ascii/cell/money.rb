require "./lib/csv_ascii/cell/base"

module CSVASCII
  module Cell
    class Money < CSVASCII::Cell::Base
      SEPARATOR = "."
      FORMATTED_SEPARATOR = ","

      def initialize(data)
        @data = Array(format_data(data))
      end

      def align
        :right
      end

      private

      def format_data(data)
        data.split(SEPARATOR).join(FORMATTED_SEPARATOR)
      end
    end
  end
end
