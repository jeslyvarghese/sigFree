require 'uri'
class URLDecoder
	def self.decode(encoded_string)
		return URI.unescape(encoded_string)
	end
end