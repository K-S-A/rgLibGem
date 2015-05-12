module RgLibGem
	class Book < Author
	attr_reader :title, :author

		def initialize(title, author)
			trim(title, author)
			author.capitalize!
			@title, @author = title, author
		end
	end
end
