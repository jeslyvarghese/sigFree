require 'rgl/adjacency'
require 'rgl/traversal'
module Filter
	class InstructionFlowTracker
		def self.showFlow(graph)
			bfs_iterator = RGL::DFSIterator.new(graph,graph.detect{|x| true})
			vertex_count = Array.new
			vertex_count.push 0
			iteration_vertex_count = 0
			vertex = bfs_iterator.basic_forward
			begin
				while true
					p "On Vertex:#{vertex}"
					p "Has Neighbours:#{graph.adjacent_vertices(vertex)}"
					if graph.adjacent_vertices(vertex).count == 0
						iteration_vertex_count+=1
						vertex_count.push iteration_vertex_count
						iteration_vertex_count=0
						else
						iteration_vertex_count+=1
						end
						vertex = bfs_iterator.basic_forward
				end 
			rescue RGL::NoVertexError
				p "Vertex: #{vertex_count}"
				vertex_count
			end
		end
	end
end