module RgLibGem
	class Order < Library
	attr_reader :reader_id, :book, :author, :date

		def initialize(reader_id, book, author, date = Time.now.strftime("%Y%m%d"))
			raise Exception unless reader_id.is_a?(Fixnum) && book.is_a?(String) && author.is_a?(String)
		
			date = date.is_a?(String) ? date.strip : date.is_a?(Date) ? date.strftime("%Y%m%d") : raise
			@date = date > Time.now.strftime("%Y%m%d") ? raise : date
			[book, author].each { |val|  val.strip!; val.capitalize! }
		
			@reader_id, @book, @author = reader_id, book, author
		end
	end	
end
