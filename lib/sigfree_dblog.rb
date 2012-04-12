require 'mongo'

module Logs
	class MongoDB
		
		def initialize
			connection = Mongo::Connection.new
			db = connection.db "sigfree"
			@collection = db.collection("logs")
		end

		def add(json)
			@collection.insert json
		end
	end
end