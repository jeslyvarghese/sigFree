require 'uri	'
class URLDecoder
	def decode(enocoded_string)
		return URI.unescape(encoded_string)
	end
end