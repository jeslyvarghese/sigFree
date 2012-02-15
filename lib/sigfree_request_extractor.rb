class RequestExtract
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
			elsif @unfiltered_request[0].match(/POST/)!=nil then
				request_type = 'post'
				extract_post(@unfiltered_request[0])
			end
		end

		def extract_get(line)
			@get = line.sub(/GET\s/,"").sub(/\s.*/,"").
		end
	
		def extract_post
 			@unfiltered_request.each{|line| }
		end
	}