require 'em-proxy'
require 'require_relative'

require_relative('sigfree_request_extractor.rb')
require_relative('sigfree_request_extractor.rb')


module SigFree
  class Proxy
    attr_reader :data
    
    def initialize(listen_host='localhost',listen_port,forward_host='localhost',forward_port)
    	@listening_host=listen_host
    	@listening_port = listen_port
    	@forward_host = forward_host
    	@forward_port = forward_port
    end

    def start
    	Proxy.start(:host=>@listening_host,:port=>@listening_port,:debug=>true) do |conn|
    		conn.server :srv, :host=>@forward_host, :port=>@forward_port
    		#to_process the request scheme
    		conn.on_data do |data|
    		  request_extractor = RequestExtractor.new(data)#call extractor
          if request_extractor.get!=nil
            header=request_extractor.get
          elsif request_extractor.post !=nil
            header = request_extractor.post
            content = request_extractor.content
          end
        
          #call uri decoder
          #call ascii filter
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