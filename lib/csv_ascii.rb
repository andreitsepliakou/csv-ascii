require "./lib/csv_ascii/parser"
require "./lib/csv_ascii/printer"

module CSVASCII
  def self.call(file_name)
    parser = CSVASCII::Parser.new(file_name)
    parser.call
    rows = parser.rows
    column_widths = parser.cell_max_widths
    CSVASCII::Printer.new(rows, column_widths: column_widths).call
  end
end
