require 'udis86'
require 'rgl/adjacency'
require 'graph'

$control_transfer = Set.new(['ja','jae','jnz','jb','jbe','jc','jcxz','jecxz','je','jg','jge','jl','jle','jna','jnae','jnb','jnbe','jnc','jne','jng','jnge','jnl','jnle','jno','jnp','jns','jnz','jo','jp','jpe','jpo','js','jz','ja','jae','jbe','jc','je','jz','jg','jge'])
module Distler

	class InstructionProcessor
		
		def self.to_instruction(filtered_array)
			instruction_array = Array.new
			filtered_array = filtered_array.map {|elem| "\\x#{elem}"}
			filtered_array
		end
	end

	class Disassembler
		def init
			@ud = FFI::UDis86::UD.create(
		  	:mode => 32,
		  	:vendor => :intel,
		  	:syntax => :att
			)
		end

		def disassemble(inst_ar)
			@ud = FFI::UDis86::UD.create(
		  	:mode => 32,
		  	:vendor => :intel,
		  	:syntax => :att
			)
			instructions = Hash.new
			instructions['Instruction'] = Hash.new
			instructions['Mnemonic'] = Hash.new
			puts "inst array:#{inst_ar}"
			inst_ar.each do |inst|
				@ud.input_buffer = inst	
				@ud.disas do |insn|
					offset = insn.insn_offset
					instructions['Instruction'][offset] = insn
					instructions['Mnemonic'][offset] = insn.mnemonic
				end
			end
			instructions
		end
	end

	class EIFG
		def init(inst_hash)
			@inst_hash = inst_hash
			@eifg_array = Array.new
			puts "inst_hash#{@inst_hash}"
		end

		def construct_graph(inst_hash)
			eifg_array = Array.new
			count = 0
			decision = 'unblock'
			inst_hash['Mnemonic'].each do |key,value|
				eifg = RGL::DirectedAdjacencyGraph.new
				graph = Graph.new
				graph.colorscheme :greens
				graph.fillcolor 'saddlebrown'
				graph.arrowsize 12
				graph.style 'bold'
				graph.boxes
				until value==nil do 
					u =  value
					if $control_transfer.member?(value) 
						jmp_adr = get_address(value)
						if inst_hash.has_key?(jmp_adr)	  
							v = inst_hash['Mnemonic'][jmp_adr]
							key = inst_hash['Mnemonic'][jmp_adr]
						else
							v = 'external'
							value = nil
						end	
					else
						v = inst_hash['Mnemonic'][key+1]
						value =  inst_hash['Mnemonic'][key+1]
						key = key+1 
					end
					eifg.add_vertex(u)
					eifg.add_vertex(v)
					eifg.add_edge(u,v)
					graph.edge(u,v)
				end
				graph.save "graphs/sigfree#{Time.new.nsec}" 'jpg'
				count+=1
				size = eifg.size
				decision = 'block' if size>15
				puts "Instruction Set Size:#{size}"
				eifg_array<<eifg	
			end
			puts eifg_array
			decision
		end

		def show_graph(eifg_array)
			eifg_array.each do |eifg|
				p eifg.to_s
			end
		end
		def get_address(inst)
			split = inst.split(' ')
			return split[1]
		end
	end
end


