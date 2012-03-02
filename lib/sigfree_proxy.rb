require 'em-proxy'
require 'require_relative'

require_relative('sigfree_request_extractor.rb')
require_relative('sigfree_url_decoder.rb')
require_relative('sigfree_ascii_filter.rb')

module SigFree
  class SiProxy
    attr_reader :data
    
    def initialize(listen_host,listen_port,forward_host,forward_port)
    	@listening_host=listen_host
    	@listening_port = listen_port
    	@forward_host = forward_host
    	@forward_port = forward_port
    end


    def sig_start
     Proxy.start(:host => "0.0.0.0", :port => 9060, :debug => true) do |conn|
       conn.server :srv, :host => "127.0.0.1", :port => 9061
        #to_process the request scheme
    		conn.on_data do |data|
    	  puts data
        request_extractor = RequestExtractor.new(data) #call extractor
          request_extractor.extract_request
          if request_extractor.get!=nil
            header=request_extractor.get
          elsif request_extractor.post !=nil
            header = request_extractor.post
            content = request_extractor.content
          end
          #call uri decoder
          url_decoded_header = URLDecoder.decode(header)
          url_decoded_content = URLDecoder.decode(content) unless content.nil?
          print "Decoded Header: #{url_decoded_header}\nDecoded Content:#{url_decoded_content}"
          #call ascii
          ascii_array_header = ASCII::String.new(url_decoded_header).ascii_int
          ascii_filtered_header = ASCII::Filter.filter(ascii_array_header)
          #ascii_filtered_content = Filter.new(String.new( url_decoded_content).ascii_int).filter unless content.nil?
          print "ASCII Filtered Content: #{ascii_filtered_header}\nContent:"
          print "In Characters:#{ASCII::String.ascii_to_string(ascii_filtered_header)}"
          #call instruction distler
          #call threshold match
          data
        end

    		#to_process the response scheme
    		conn.on_response do |backend,resp|
    		  resp
        end

    		#termination logic
    		conn.on_finish do |backend,name|
    			unbind if backend==:srv
    		end
    	end
    end
  end
end