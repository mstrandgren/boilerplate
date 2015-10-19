
server = require('mflib/Server')

server.start
	port: process.env.PORT
	cors: true
	webServer: (app) ->
		app.use (request, response) ->
			response.statusCode = 200
			response.end "Hello, world!"

console.log "Started server on port #{port}"