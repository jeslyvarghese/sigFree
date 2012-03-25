require 'udis86'
require 'rgl'

$control_transfer = Set.new['ja','jae','jnz','jb','jbe','jc','jcxz','jecxz','je','jg','jge','jl','jle','jna','jnae','jnb','jnbe','jnc','jne','jng','jnge','jnl','jnle','jno','jnp','jns','jnz','jo','jp','jpe','jpo','js','jz','ja','jae','jbe','jc','je','jz','jg','jge']
module Distler

	class InstructionProcessor
		
		def init(instruction_array)
			@instruction_string = Array.new
			instruction_array.each {|elem| @instruction_string<<"\\x#{elem}"}
		end

		def get_instruction
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
			offset = 0x0
			instructions = Hash.new
			inst_ar.each do |inst|
				ud.input_buffer = inst	
				ud.disas do |insn|
					offset = insn.insn_offset
					instructions['Instruction'][offset] = insn
					instructions['Mnemonic'][offset] = insn.insn_mnemonic
				end
			end
		end
	end

	class EIFG
		def init(inst_mnemonic,inst)
			@inst_hash = inst_hash
			@eifg_array = Array.new
		end

		def construct_graph
			@inst_hash['Mnemonic'].each do |key,value|
				eifg = RGL::DirectedAdjacencyGraph.new
				until value==null do 
					if $control_transfer.member?(value) 
						eifg.add_vertex(value)
						jmp_adr = get_address(value)
						if @inst_hash.has_key(jmp_adr)? 
							add_vertex(@inst_hash['Mnemonic'][jmp_adr])
							eifg.add_edge(key,@inst_hash['Mnemonic'][jmp_adr])
							key = @inst_hash['Mnemonic'][jmp_adr]
						else
							eifg.add_edge(key,'external')
							eifg.value = null
						end	
					else
						eifg.add_vertex(value)
						eifg.add_vertex(@inst_hash['Mnemonic'][key+1])
						eifg.add_edge(value,@inst_hash['Mnemonic'][key+1])
						value =  @inst_hash['Mnemonic'][key+1]
						key = key+1 
					end
					@eifg_array<<eifg
				end	
			end
		end

		def show_graph
			@eifg_array.each do |eifg|
				p eifg.to_s
			end
		end
		def get_address(inst)
			split = inst.split(' ')
			return split[1]
		end
	end
end


