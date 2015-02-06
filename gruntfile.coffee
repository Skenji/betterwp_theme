module.exports = (grunt)->
	
	# Load Grunt Tasks
	require('load-grunt-tasks')(grunt)

	debug = !!grunt.option('debug')

	# Configure Grunt Tasks

	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		bower:
			install:
				options:
					bowerOptions:
						production: true

		stylus:

			options:
				define:
					DEBUG: debug
				use: [
					()-> require('autoprefixer-stylus')('last 2 versions', 'ie 8', 'ie 9')
					debug or require('csso-stylus')
				]

			compile:
				files:
					'assets_build/stylesheets/style.css': 'assets/stylesheets/style.styl'

		coffee:

			compile:
				files:
					'assets_build/javascripts/site.js': 'assets/javascripts/*.coffee'

		uglify:
			my_target:
				files:
					'assets_build/javascripts/site.min.js': 'assets_build/javascripts/site.js'
	
		watch:

			stylus:
				files: 'assets/stylesheets/*.styl'
				tasks: 'stylus'

			coffee:
				files: 'assets/javascripts/*.coffee'
				tasks: 'coffee'

			uglify:
				files: 'assets_build/javascripts/*.js'
				tasks: 'uglify'

			livereload:
				options:
					livereload: true
				files: ['assets_build/**/*']					

	grunt.registerTask 'default', ['stylus', 'coffee']