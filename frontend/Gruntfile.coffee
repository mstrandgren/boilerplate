module.exports = (grunt) ->
	require('time-grunt')(grunt)

	grunt.initConfig({})

	require('load-grunt-tasks')(grunt)

	grunt.loadTasks('grunt_tasks')
	grunt.registerTask('default', ['build'])
