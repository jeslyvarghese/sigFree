require 'em-proxy'


class SigFreeProxy
  attr_reader :data
  
  def initialize(listen_host='localhost',listen_port,forward_host='localhost',forward_port)
  	@listening_host=listen_host
  	@listening_port = listen_port
  	@forward_host = forward_host
  	@forward_port = forward_port
  end

  def start
  	Proxy.start(:host=>@listening_host,:port=>@listening_port,:debug=>true) do |conn|
     conn.server :srv, :host => @forward_host, :port =>@forward_port

  		#to_process the request scheme
  		conn.on_data do |data|
  		end

  		#to_process the response scheme
  		conn.on_response do |backend,resp|
  		end

  		#termination logic
  		conn.on_finish do |backend,name|
  			unbind if backend==:srv
  		end
  	end
  end
end