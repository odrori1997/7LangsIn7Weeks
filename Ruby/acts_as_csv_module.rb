#---
# Excerpted from "Seven Languages in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/btlang for more book information.
#---

class CsvRow
	attr_accessor :header_row, :content_row

	def initialize(header_row, content_row)
		@header_row = header_row
		@content_row = content_row
	end


	def self.method_missing name, *args
		col = @header_row.index(name.to_s)
		return @content_row[col]
	end

end

module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end
  
  module InstanceMethods 
    def read
    	@csv_rows = []
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
        @csv_rows << CsvRow.new(@headers, csv_contents)
      end
    end
    
    attr_accessor :headers, :csv_contents, :csv_rows

    def initialize
      read 
    end
  
  	def each &block
  		@csv_rows.each &block
  	end
  end

end

class RubyCsv  # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect

