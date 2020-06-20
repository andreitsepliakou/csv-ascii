require 'csv'
require "./lib/csv_ascii/cell/int"
require "./lib/csv_ascii/cell/money"
require "./lib/csv_ascii/cell/string"
require "./lib/csv_ascii/row"

module CSVASCII
  class Parser
    SEPARATOR = ";"
    CELL_KLASSES_MAPPING = {
      "int" => CSVASCII::Cell::Int,
      "string" => CSVASCII::Cell::String,
      "money" => CSVASCII::Cell::Money
    }

    attr_reader :rows, :cell_max_widths

    def initialize(file_name)
      @file_name = file_name
      @rows = []
      @cell_max_widths = []
    end

    def call
      CSV.foreach(file_name, col_sep: SEPARATOR).each_with_index do |csv_row, csv_row_index|
        if csv_row_index.zero?
          @cell_klasses = build_cell_klasses(csv_row)
          @cell_max_widths = Array.new(cell_klasses.count, 0)
          next
        end

        @rows << build_row(csv_row)
      end
    end

    private

    attr_reader :file_name, :cell_klasses

    def build_cell_klasses(csv_row)
      csv_row.map do |cell_type|
        CELL_KLASSES_MAPPING.fetch(cell_type) do
          raise StandardError("Unsupported data type: #{cell_type}")
        end
      end
    end

    def build_row(csv_row)
      cells = csv_row.map.with_index do |csv_cell, csv_cell_index|
        cell_klasses[csv_cell_index].new(csv_cell).tap do |cell|
          update_cell_max_widths(cell, csv_cell_index)
        end
      end
      CSVASCII::Row.new(cells)
    end

    def update_cell_max_widths(cell, cell_index)
      cell_max_widths[cell_index] = cell.width if cell.width > cell_max_widths[cell_index]
    end
  end
end
