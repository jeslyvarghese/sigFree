require 'rgl/adjacency'
require 'rgl/traversal'
module Filter
	class InstructionFlowTracker
		def self.showFlow(graph)
			bfs_iterator = RGL::DFSIterator.new(graph,graph.detect{|x| true})
			vertex_count = Array.new
			iteration_vertex_count = 0
			begin
				while true
					vertex = bfs_iterator.basic_forward
					if bfs_iterator.finished_vertex? vertex
						iteration_vertex_count+=1
						vertex_count.push iteration_vertex_count
						iteration_vertex_count=0
						else
						iteration_vertex_count+=1
						end	
				end 
			rescue RGL::NoVertexError
				vertex_count
			end
		end
	end
end