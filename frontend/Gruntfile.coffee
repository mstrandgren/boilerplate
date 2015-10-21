module.exports = (grunt) ->
	grunt.initConfig({})
	require('load-grunt-tasks')(grunt)
	require('mflib/grunt/build')(grunt)
	require('mflib/grunt/serve')(grunt)
	require('mflib/grunt/deploy')(grunt)

	grunt.config.merge
		mf:
			# aws: grunt.file.readJSON('grunt-aws.json')
			coffeeIn: 'main.cjsx'
			# jsOut: 'app.js'
			# port: 9001
			deployPath:
				production: ''
				stage: ''
			buckets:
				production: ''
				stage: ''

		source_types: grunt.config.get('source_types').concat(['cjsx'])
		browserify:
			all:
				options:
					transform: ['coffee-reactify']
					browserifyOptions:
						extensions: ['.coffee', '.cjsx']


	grunt.registerTask('default', ['build'])
