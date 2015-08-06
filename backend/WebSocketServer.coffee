
connections = new Set()
http = require('http')
https = require('https')
fs = require('fs')
path = require('path')

# Proxywrap is used to work with AWS ELB's ProxyProtocol, which is needed to make websockets work
proxiedHttp = require('proxywrap').proxy(http, strict: false)



MAX_CONNECTIONS = 1000

start = ({port, httpsPort, onConnect, onMessage, onClose}) ->

	app = require('express')()

	port ?= 9000
	httpsPort ?= port + 43

	app.get '/', (req, res) ->
		res.header('Content-type', 'text/plain')
		res.send "Polo!"

	httpServer = proxiedHttp.createServer(app).listen(port)

	options =
		key: fs.readFileSync(path.resolve(__dirname, 'server.key'))
		cert: fs.readFileSync(path.resolve(__dirname, 'server.crt'))
	httpsServer = https.createServer(options, app).listen(httpsPort)


	WebSocketServer = require('ws').Server
	wsServer = new WebSocketServer
		server: httpServer

	wsServer.on 'connect', (connection) ->
		addConnection(connection, {onConnect, onMessage, onClose})

addConnection = (connection, {onConnect, onMessage, onClose}) ->
	if connections.size > MAX_CONNECTIONS
		console.error('Max connections')
		return

	connections.add(connection)
	console.log "New connection, #{connections.size} connections in total"

	removeConnection = (connection) ->
		if connections.has(connection)
			connections.delete(connection)
			onClose?(connection)

	connection.on 'close', ->
		removeConnection(connection)

	connection.on 'error', (error) ->
		console.error error
		removeConnection(connection)

	connection.on 'disconnect', ->
		removeConnection(connection)

	connection.on 'message', (data) ->
		message = JSON.parse(data.utf8Data)
		onMessage?(connection, message)

broadcast = (message) ->
	connections.forEach (connection) ->
		connection.send(JSON.stringify(message))

module.exports = {start, broadcast}