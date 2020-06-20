module CSVASCII
  module Cell
    class Base
      def initialize(data)
        @data = Array(data || "")
      end

      def to_s(cell_data_index)
        data[cell_data_index] || ""
      end

      def height
        1
      end

      def width
        data.map(&:length).max
      end

      private

      attr_reader :data
    end
  end
end
