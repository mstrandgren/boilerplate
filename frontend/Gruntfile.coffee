module.exports = (grunt) ->
	grunt.initConfig({})
	require('load-grunt-tasks')(grunt)
	require('mflib/grunt/build')(grunt)
	require('mflib/grunt/serve')(grunt)
	require('mflib/grunt/deploy')(grunt)
	require('mflib/grunt/react')(grunt)

	grunt.config.merge
		mf:
			# aws: grunt.file.readJSON('grunt-aws.json')
			coffeeIn: 'main.cjsx'
			deployPath:
				production: ''
				stage: ''
			bucket:
				production: ''
				stage: ''

			dependencies: [
					'lodash'
					'react'
					'react-dom'
					'react-router'
					'react-addons-css-transition-group'
					'history/lib/createBrowserHistory'
				]

	grunt.registerTask('default', ['build'])

