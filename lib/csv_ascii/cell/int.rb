require "./lib/csv_ascii/cell/base"

module CSVASCII
  module Cell
    class Int < CSVASCII::Cell::Base
      def align
        :right
      end
    end
  end
end
