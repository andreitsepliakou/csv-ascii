require 'csv'
require "./lib/csv_ascii/cell/int"
require "./lib/csv_ascii/cell/money"
require "./lib/csv_ascii/cell/string"
require "./lib/csv_ascii/row"
require "./lib/csv_ascii/parser/result"

module CSVASCII
  class Parser
    SEPARATOR = ";"
    CELL_KLASSES_MAPPING = {
      "int" => CSVASCII::Cell::Int,
      "string" => CSVASCII::Cell::String,
      "money" => CSVASCII::Cell::Money
    }

    def initialize(file_name)
      @file_name = file_name
    end

    def call
      result = CSVASCII::Parser::Result.new

      CSV.foreach(file_name, col_sep: SEPARATOR).each_with_index do |csv_row, csv_row_index|
        process_csv_row(csv_row, csv_row_index, result)
      end

      result
    end

    private

    attr_reader :file_name, :cell_klasses

    def process_csv_row(csv_row, csv_row_index, result)
      if csv_row_index.zero?
        build_cell_klasses(csv_row)
        result.setup_cell_max_widths(csv_row.count)
        return
      end

      result.rows << build_row(csv_row, result)
    end

    def build_cell_klasses(csv_row)
      @cell_klasses = csv_row.map do |cell_type|
        CELL_KLASSES_MAPPING.fetch(cell_type) do
          raise StandardError, "Unsupported data type: #{cell_type}"
        end
      end
    end

    def build_row(csv_row, result)
      cells = cell_klasses.count.times.map do |csv_cell_index|
        csv_cell = csv_row[csv_cell_index]
        build_cell(csv_cell, csv_cell_index).tap do |cell|
          update_cell_max_widths(cell, csv_cell_index, result)
        end
      end
      CSVASCII::Row.new(cells)
    end

    def build_cell(csv_cell, csv_cell_index)
      cell_klasses[csv_cell_index].new(csv_cell)
    end

    def update_cell_max_widths(cell, cell_index, result)
      result.cell_max_widths[cell_index] = cell.width if cell.width > result.cell_max_widths[cell_index]
    end
  end
end
