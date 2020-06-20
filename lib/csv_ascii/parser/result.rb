module CSVASCII
  class Parser
    class Result
      attr_reader :rows, :cell_max_widths

      def initialize
        @rows = []
        @cell_max_widths = []
      end

      def setup_cell_max_widths(cells_count)
        @cell_max_widths = Array.new(cells_count, 0)
      end
    end
  end
end
