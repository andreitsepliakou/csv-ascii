module CSVASCII
  class Printer
    ALIGNS = {
      CSVASCII::Cell::Int => "right",
      CSVASCII::Cell::String => "left",
      CSVASCII::Cell::Money => "right"
    }

    def initialize(rows, column_widths:)
      @rows = rows
      @column_widths = column_widths
    end

    def call
      print_horizontal_delimiter
      puts
      rows.each do |row|
        print_row(row)
        print_horizontal_delimiter
        puts
      end
    end

    private

    attr_reader :rows, :column_widths

    def print_row(row)
      row.height.times do |cell_data_index|
        print_vertical_delimiter
        row.cells.each_with_index do |cell, cell_index|
          print_cell(cell, cell_index, cell_data_index)
          print_vertical_delimiter
        end
        puts
      end
    end

    def print_cell(cell, cell_index, cell_data_index)
      value = cell.to_s(cell_data_index)
      spaces_count = column_widths[cell_index] - value.length
      if ALIGNS[cell.class] == "right"
        spaces_count.times { print " " }
        print value
      else
        print value
        spaces_count.times { print " " }
      end
    end

    def print_horizontal_delimiter
      print "+"
      column_widths.each do |column_width|
        column_width.times { print "-" }
        print "+"
      end
    end

    def print_vertical_delimiter
      print "|"
    end
  end
end
