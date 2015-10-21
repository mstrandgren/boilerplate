
document.addEventListener 'DOMContentLoaded', ->
	React.render(<Hello />, document.body)

Hello = React.createClass
	render: ->
		<h1>Hello, World</h1>