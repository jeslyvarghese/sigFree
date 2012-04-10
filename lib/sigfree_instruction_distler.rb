require 'udis86'
require 'rgl/adjacency'
require 'rgl/dot'
require 'graph'

$control_transfer = Set.new(['ja','jae','jnz','jb','jbe','jc','jcxz','jecxz','je','jg','jge','jl','jle','jna','jnae','jnb','jnbe','jnc','jne','jng','jnge','jnl','jnle','jno','jnp','jns','jnz','jo','jp','jpe','jpo','js','jz','ja','jae','jbe','jc','je','jz','jg','jge'])
module Distler

	class InstructionProcessor
		
		def self.to_instruction(filtered_array)
			instruction_array = Array.new
			filtered_string = filtered_array.join(' ')
			filtered_array = filtered_array.map {|elem| "\\x#{elem}"}
			filtered_array
			#filtered_string
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
			instructions['Length'] = Hash.new
			puts "inst array:#{inst_ar}"
			inst = inst_ar
			inst_ar.each do |inst|
				@ud.input_buffer = inst	
				@ud.disas do |insn|
					offset = insn.insn_offset
					p insn
					instructions['Instruction'][offset] = insn.to_s
					instructions['Mnemonic'][offset] = insn.mnemonic
					instructions['Length'][offset] =insn.insn_length
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
			eif_graph = RGL::DirectedAdjacencyGraph.new
			di_graph = Graph.new

			instruction_array = Array.new
			digraph do
			
			inst_hash['Mnemonic'].each do |key,value| #add all instructions to the graph
				eif_graph.add_vertex value.to_s unless value==nil
				#node value.to_s
			end
			
			inst_hash['Instruction'].each do |key,value| #add all instructions to the graph
				node value unless value==nil
			end
			
			address_pointer = 0
			last_address = inst_hash['Mnemonic'].keys.max

			while address_pointer<=last_address do
				inst = inst_hash['Instruction'][address_pointer]
				mnemonic = inst_hash['Mnemonic'][address_pointer]
				length = inst_hash['Length'][address_pointer]
				if	mnemonic == 'illegal'
					instruction_array[address_pointer] = inst
					target = 'illegal'
					target_mnemonic = 'illegal'
				else
					instruction_array[address_pointer]=inst
					if $control_transfer.include? mnemonic
						jmp_address = get_address(inst)
						if jmp_address>last_address
							target = 'external'
							target_mnemonic = 'external'
						else
							target = inst_hash['Instruction'][jmp_address]
							target_mnemonic = inst_hash['Mnemonic'][jmp_address]
						end
					else
						target = inst_hash['Instruction'][address_pointer+length]
						target_mnemonic = inst_hash['Mnemonic'][address_pointer+length]
					end
				end
				if target_mnemonic==nil
					address_pointer+=length
					next
				end
				eif_graph.add_edge inst.to_s,target.to_s
				edge inst.to_s, target.to_s
				#p di_graph.edge mnemonic, target
				#begin
					address_pointer+=length
				#end while inst_hash['Instruction'][address_pointer]==nil||address_pointer>last_address
			end
			save 'graphs/op','jpg'
			end
			eif_graph
		end

		def show_graph(eifg_array)
			eif_graph
		end
		
		def get_address(inst)
			split = inst.split(' ')
			return split[1]
		end
	end
end

class SubGraph
	def self.reduce_subgraph(graph)
		subgraphs = graph.subgraphs
	end
end

