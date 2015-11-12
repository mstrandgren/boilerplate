React = require('react')
{render} = require('react-dom')

document.addEventListener 'DOMContentLoaded', ->
	render(<Hello />, document.body)

Hello = React.createClass
	render: ->
		<h1>Hello, World</h1>