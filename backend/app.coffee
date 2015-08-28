
server = require('./Server.coffee')

server.start
	httpPort: process.env.PORT ? 9000
	cors: true
	webServer: (app) ->
		app.use (request, response) ->
			response.statusCode = 200
			response.end "Hello, world!"
