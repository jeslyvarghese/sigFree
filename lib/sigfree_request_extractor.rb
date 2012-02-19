class RequestExtractor
	{
		attr_writer :request
		attr_reader :get, :post, :content

		def initialize(request)
			@unfiltered_request = request.split("\n")
		end

		def extract_request
			if @unfiltered_request[0].match(/GET/) != nil then
				request_type = 'get'
				extract_get(@unfilter_request[0])
			elsif @unfiltered_request[0].match(/POST/)!=nil then #contents without post are not handled. Write handler
				request_type = 'post'
				extract_post(@unfiltered_request[0])
			end
		end

		def extract_get(line)
			@get = line.sub(/GET\s/,"").sub(/\s.*/,"").
		end
	
		def extract_post
			content_length = nil
 			#@unfiltered_request.each{|line,key| content_length=line.sub(/Content-Length:\s/,"").to_i if line.match(/Content-Length:/)}
 			content_index = @unfiltered_request.index(/Content-Length:/)+1
 			@content = ((content_index..@unfiltered_request.length-1).collect{|line| line}).to_s
		end
	}