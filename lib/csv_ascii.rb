require "./lib/csv_ascii/parser"
require "./lib/csv_ascii/printer"

module CSVASCII
  def self.call(file_name)
    parser_result = CSVASCII::Parser.new(file_name).call
    CSVASCII::Printer.new(parser_result.rows, column_widths: parser_result.cell_max_widths).call
  end
end
