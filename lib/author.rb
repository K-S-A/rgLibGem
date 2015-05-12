module RgLibGem
	class Author < Library
	attr_reader :name, :biography

		def initialize(name, biography)
			trim(name, biography)
			biography = biography.slice(0, 1).upcase + biography.slice(1..-1)
			@name, @biography = name, biography		
		end
	
		def trim(name, description)
			raise Exception, "Attributes should take only string values." unless name.is_a?(String) && description.is_a?(String)
			name.strip!; name.capitalize!; description.strip!
			raise Exception if name.empty? || description.empty? 
		end
	
	end
end
