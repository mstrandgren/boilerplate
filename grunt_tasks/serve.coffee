module.exports = (grunt) ->
	grunt.config.merge

		serve:
			template:
				tasks: [
					'build:template'
					'connect:template'
					'watch'
				]

		connect:
			template:
				options:
					hostname: '*'
					port: 9001
					base: '<%= template.build %>'
					livereload: false
					open: false

		watch:
			coffee:
				options:
					livereload: false
				files: [
					'src/{,**/}*.coffee'
					'src/{,**/}*.cjsx'
				]
				tasks: [
					'browserify'
					# 'cacheBust'
					# 'manifest'
				]
			html:
				options:
					livereload: false
				files: [
					'src/{,**/}*.html'
				]
				tasks: [
					'copy:html'
					# 'cacheBust'
					# 'manifest'
				]
			less:
				options:
					livereload: false
				files: [
					'src/{,**/}*.less'
				]
				tasks: [
					'less'
					# 'cacheBust'
					# 'manifest'
				]

	grunt.registerMultiTask 'serve', 'Serve serve script locally', ->
		grunt.task.run @data.tasks

