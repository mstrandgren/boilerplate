
server = require('./Server.coffee')

port = process.env.PORT ? 9000
server.start
	httpPort: port
	cors: true
	webServer: (app) ->
		app.use (request, response) ->
			response.statusCode = 200
			response.end "Hello, world!"

console.log "Started server on port #{port}"