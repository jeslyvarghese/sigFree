class RequestExtractor

		def initialize(request)
			@unfiltered_request = request.split(/\n/)
			#@get =nil
			#@post = nil
			#@content = initialize
		end

		def extract_request
			header = @unfiltered_request[0]
			if header.match(/GET/) != nil then
				request_type = 'get'
				extract_get(header)
			elsif header.match(/POST/)!=nil then #contents without post are not handled. Write handler
				request_type = 'post'
				extract_post(header)
			end
		end

		def extract_get(line)
			@get = line.sub(/GET\s\//,"").sub(/\s.*/,"")
		end
	
		def extract_post(line)
			@post = line.sub(/POST\s\//,"").sub(/\s.*/,"")
			#content_length = nil
 			#@unfiltered_request.each{|line,key| content_length=line.sub(/Content-Length:\s/,"").to_i if line.match(/Content-Length:/)}
 			content_index = @unfiltered_request.index(/Content-Length:/)+1
 			@content = ((content_index..@unfiltered_request.length-1).collect{|line| line}).to_s
		end

		def get
			@get
		end
		attr_writer :request
		attr_reader :get, :post, :content
	end
