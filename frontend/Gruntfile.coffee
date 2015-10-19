module.exports = (grunt) ->
	grunt.initConfig({})
	require('load-grunt-tasks')(grunt)
	grunt.loadTasks('grunt_tasks')
	require('mflib/grunt/build')(grunt)
	require('mflib/grunt/serve')(grunt)

	grunt.config.merge
		mf:
			jsOut: 'main.js'
			port: 9002
			awsCredentials: 'grunt-aws.json'
			deployPath: ''
			buckets:
				production: ''
				stage: ''


	grunt.registerTask('default', ['build'])
