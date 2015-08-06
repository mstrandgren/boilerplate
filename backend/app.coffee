
wss = require('./WebSocketServer.coffee')

wss.start
	port: process.env.PORT ? 9000
	onClose: (connection) ->
		removeVillager(connection)

	onMessage: (connection, message) ->
		if message.isMobile
			return addVillager(connection)
		if message.villagerRotation

			return updateVillagerRotation(connection, message.villagerRotation)

