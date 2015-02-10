module.exports = (grunt)->
	
	# Load Grunt Tasks
	require('load-grunt-tasks')(grunt)

	debug = !!grunt.option('debug')

	# Configure Grunt Tasks

	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		bower_concat:
			all:
				dest: 'assets_build/javascripts/bower.js'
				cssDest: 'assets_build/stylesheets/bower.css'

		copy:
			font_awesome:
				expand: true
				flatten: true
				src: 'bower_components/font-awesome/fonts/*'
				dest: 'assets_build/fonts'

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

			bower:
				options:
					mangle: true
					compress: true
				files:
					'assets_build/javascripts/bower.min.js': 'assets_build/javascripts/bower.js'

			my_target:
				files:
					'assets_build/javascripts/site.min.js': 'assets_build/javascripts/site.js'

		cssmin:
			target:
				files:
					'assets_build/stylesheets/style.min.css': ['assets_build/stylesheets/bower.css', 'assets_build/stylesheets/style.css']
	
		watch:

			stylus:
				files: 'assets/stylesheets/*.styl'
				tasks: ['stylus', 'cssmin']

			coffee:
				files: 'assets/javascripts/*.coffee'
				tasks: 'coffee'

			uglify:
				files: 'assets_build/javascripts/site.js'
				tasks: 'uglify'

			livereload:
				options:
					livereload: true
				files: ['assets_build/**/*']

	# Registering Tasks

	#Default

	grunt.registerTask 'default', ['stylus', 'coffee']

	#Assets precompile task
	grunt.registerTask 'assets:precompile', ['bower_concat', 'stylus', 'coffee', 'uglify', 'cssmin', 'copy']