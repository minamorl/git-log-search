gulp          = require 'gulp'
del           = require 'del'
bower         = require 'gulp-bower'
uglify        = require 'gulp-uglify'
gutil         = require 'gulp-util'
sass          = require 'gulp-sass'
runSequence   = require 'run-sequence'
merge         = require 'merge'
layout        = require 'gulp-layout'
markdown      = require 'gulp-markdown'
jade          = require 'gulp-jade'
fs            = require 'fs'
path          = require 'path'
marked        = require 'marked'
htmlmin       = require 'gulp-htmlmin'
cssmin        = require 'gulp-minify-css'
webserver     = require 'gulp-webserver'
webpack       = require 'webpack'
flatten       = require 'gulp-flatten'
webpackConfig = require "./webpack.config.coffee"

gulp.task 'clean', ->
  del ['.tmp', 'dist']


gulp.task 'compress', ['compress:html', 'compress:css']

gulp.task 'compress:html', ->
  gulp.src 'dist/**/*.html', {base: "."}
    .pipe htmlmin({collapseWhitespace: true})
    .pipe (gulp.dest '.')

gulp.task 'compress:css', ->
  gulp.src 'dist/**/*.css', {base: "."}
    .pipe cssmin()
    .pipe (gulp.dest '.')

gulp.task 'bower', ->
  bower()
    .pipe flatten()
    .pipe (gulp.dest 'lib')

gulp.task 'sass', ->
  gulp.src('./sass/**/*.sass')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./dist/css'))

gulp.task 'default', ->
  runSequence 'clean', 'bower', 'sass', 'build', 'webpack', 'serve'

gulp.task 'deploy', ->
  runSequence 'clean', 'bower', 'sass', 'build', 'compress', 'webpack'

gulp.task 'build:index', ->
  gulp.src "./templates/index.jade"
    .pipe jade()
    .pipe gulp.dest('./dist')

gulp.task 'build', ['build:index', 'build:misc']

gulp.task 'build:misc', ->
  gulp.src(['lib/**/*', '*.html', 'css/**/*', 'js/**/*'], {base: "."})
    .pipe (gulp.dest 'dist')

gulp.task 'webpack', (callback) ->
  myConfig = Object.create(webpackConfig)
  webpack(myConfig, (err, stats) ->
    if(err)
      throw new gutil.PluginError("webpack:build", err)
    gutil.log("[webpack:build]", stats.toString({
      colors: true
    }))
    callback()
  )

gulp.task 'serve', ->
  gulp.watch './sass/**/*.sass', ->
    runSequence 'sass', 'compress'
  gulp.watch ['./templates/**/*.jade'], ->
    runSequence 'build', 'compress'
  gulp.src 'dist'
    .pipe webserver
      livereload: true,
