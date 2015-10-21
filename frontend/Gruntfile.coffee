module.exports = (grunt) ->
	grunt.initConfig({})
	require('load-grunt-tasks')(grunt)
	require('mflib/grunt/build')(grunt)
	require('mflib/grunt/serve')(grunt)
	require('mflib/grunt/deploy')(grunt)

	grunt.config.merge
		mf:
			aws: grunt.file.readJSON('grunt-aws.json')
			# jsOut: 'app.js'
			# port: 9001
			deployPath: ''
			buckets:
				production: ''
				stage: ''


	grunt.registerTask('default', ['build'])
