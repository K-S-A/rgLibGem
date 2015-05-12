module RgLibGem
	class Library

	require 'author'
	require 'book'
	require 'order'
	require 'reader'
	require 'yaml'

	attr_reader :name
	@@library = []				
	ONE_BOOK_PER_READER = true

		def initialize(name)
			name.strip!; name = name.gsub(/\s/, "_"); name.capitalize!
			raise Exception, "Should not start from digit." if name[0].gsub!(/\d/, "")
			raise Exception, "Already exists." if @@library.include?(name)
			@name = name
			@@library << @name
			@authors = {}
			@books = Hash.new([])
			@readers = Hash.new([])
			@orders = Hash.new([])				
			@top = {}
		end
	
		def add(*objs)
			objs.each do |obj|
				case 
				when obj.class == Author
					@authors[obj.name] ? raise : @authors[obj.name] = obj.biography
				when obj.class == Book
					raise Exception, "Book already added." if @books[obj.author].include?(obj.title)
					@books[obj.author] = @books[obj.author] != [] ? @books[obj.author] << obj.title : obj.title
				when obj.class == Reader
					info = [obj.name, obj.email, obj.city, obj.street, obj.house]
					raise Exception, "Reader already exists." if @readers.values.include?(info)
					reader_id = @readers.keys.max ? @readers.keys.max + 1 : 1
					@readers[reader_id] = info
				when obj.class == Order
					raise Exception, "Error: no such author/book not listed/invalid reader ID." unless @authors.include?(obj.author) && @books[obj.author].include?(obj.book) && @readers.include?(obj.reader_id)
					info = [obj.reader_id, obj.book, obj.author, obj.date]
					raise Exception, "Equivalent order already exists." if @orders.values.include?(info) && ONE_BOOK_PER_READER
					order_id = @orders.keys.max ? @readers.keys.max + 1 : 1
					@orders[order_id]	= info
					@top[obj.reader_id] = @top[obj.reader_id] ? @top[obj.reader_id] << obj.book : [obj.book]			
				else
					raise Exception, 'Incorrect object.'
				end
			end
		end
	
		def check(n)
			raise Exception, "Must be Fixnum" unless n.is_a?(Fixnum)
		end
	
		def top_readers(n = 3)				#return array of top readers ID's
			check(n)
			@top.sort_by{ |reader_id, books| books.length }.map(&:first).reverse[0..n-1]
		end
	
		def top_books(n = 1)					#return array with the names of top books
			check(n)
			@top.values.flatten.each_with_object(Hash.new(0)) { |book, obj| obj[book] += 1 }.sort_by(&:last).map(&:first)[0..n-1]
		end
	
		def bb_readers(n = 3)					#return array with readers ID's of top n books
			check(n)
			@top.select { |reader_id, books| books & self.top_books(n) != [] }.keys
		end
	
		def save
			self.instance_variables.each do |inst_var|
				File.open("../data/#{inst_var}.txt", 'w') {|f| f.write(YAML.dump(self.instance_variable_get(inst_var))) }
			end
		end 
	
		def read
			self.instance_variables.each do |inst_var|
				inst_var = YAML.load(File.read("../data/#{inst_var}.txt"))
			end
		end
	end
end
