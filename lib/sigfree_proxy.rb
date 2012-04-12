require 'em-proxy'
require 'colorize'
require 'json'

require_relative 'sigfree_request_extractor.rb'
require_relative 'sigfree_url_decoder.rb'
require_relative 'sigfree_ascii_filter.rb'
require_relative 'sigfree_instruction_distler.rb'
require_relative 'sigfree_dblog.rb'

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
      db_handler = Logs::MongoDB.new 
     Proxy.start(:host => "0.0.0.0", :port => 9060, :debug => true) do |conn|
       conn.server :srv, :host => "127.0.0.1", :port => 9061
        #to_process the request scheme
    		conn.on_data do |data|
        db_entry = Hash.new
        db_entry['Data']=data
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
          db_entry['Decoded_Header'] = url_decoded_header
          #call ascii
          ascii_array_header = ASCII::String.new(url_decoded_header).ascii_int
          ascii_filtered_header = ASCII::Filter.filter(ascii_array_header)
          #ascii_filtered_content = Filter.new(String.new( url_decoded_content).ascii_int).filter unless content.nil?
          db_entry['ASCII_Filtered_Header'] = ascii_filtered_header
          #call instruction distler
          instructionized_header = Distler::InstructionProcessor.to_instruction(ascii_filtered_header)
          db_entry['Instructionized_Header']=instructionized_header.to_s
          disassembler = Distler::Disassembler.new
          dissassembled_header = disassembler.disassemble(instructionized_header)
          puts dissassembled_header
          header_eifg = Distler::EIFG.new(dissassembled_header)
          header_eifg_outputs  = header_eifg.construct_graph(dissassembled_header)
          db_entry['Header_EIFG'] = header_eifg_outputs['Pic'] 
          invalid_flows_filtered = Distler::InvalidFilter.filter_invalid_flows(header_eifg_outputs['Grp'])
          Distler::PicGraphs.create_pic(invalid_flows_filtered,"inrm")
          #track flow of execution
          puts "JSON Entry".red
          db_handler.add  db_entry
          decision = 1
          #header_eifg.show_graph(eifg_array)
          #call threshold match
          unless decision == 'blocked'
            puts "Unblocked".green
            data 
          else
            puts "Blocked".red
            decision
          end
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