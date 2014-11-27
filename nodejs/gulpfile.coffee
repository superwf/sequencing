gulp = require("gulp")
gutil = require("gulp-util")
bower = require("bower")
concat = require("gulp-concat")
connect = require("gulp-connect")
slim = require("gulp-slim")
coffee = require("gulp-coffee")
sass = require("gulp-sass")
minifyCss = require("gulp-minify-css")
rename = require("gulp-rename")
sh = require("shelljs")
wiredep = require("wiredep")
uglify = require("gulp-uglify")
minifycss = require('gulp-minify-css')
mainBowerFiles = require('main-bower-files')

wiredep
  directory: "app/bower_components"
  bowerJson: require("./bower.json")
  src: "app/index.html"

paths =
  sass: ["app/styles/*.scss"]
  css: ["app/styles/*.css"]
  coffee: ["app/scripts/*/*.coffee", "app/scripts/*.coffee"]
  slim: ["app/views/*.slim"]

gulp.task "default", ["serve"]
gulp.task "sass", (done) ->
  gulp.src("./app/styles/*.scss").pipe(sass()).pipe(gulp.dest("./app/styles/")).pipe(minifyCss(keepSpecialComments: 0)).pipe(rename(extname: ".css")).pipe(gulp.dest("./app/styles/")).on "end", done
  null

gulp.task "coffee", (done) ->
  gulp.src("./app/scripts/*/*.coffee").pipe(coffee(bare: true)).pipe(gulp.dest("./app/scripts/"))
  gulp.src("./app/scripts/app.coffee").pipe(coffee(bare: true)).pipe(gulp.dest("./app/scripts/")).on "end", done
  return

gulp.task "slim", (done) ->
  gulp.src("./app/views/*.slim").pipe(slim(pretty: true)).pipe(gulp.dest("./app/views/")).on "end", done
  return

gulp.task "watch", ->

  gulp.watch(["app/index.html", "gulpfile.coffee"]).on "change", (e) ->
    gulp.src(e.path).pipe(connect.reload())
    return

  gulp.watch(paths.sass).on "change", (e) ->
    gulp.src(e.path).pipe(sass({
      "onError": (err)->
        console.log err
        return
    })).pipe(gulp.dest("./app/styles/")).pipe(connect.reload()).on("error", gutil.log)
    return

  gulp.watch(paths.coffee).on "change", (e) ->
    dest = e.path.replace /\/[^\/]+$/, ''
    gulp.src(e.path).pipe(coffee(bare: true).on("error", (err) ->
      console.log err
      return
    )).pipe(gulp.dest(dest)).pipe connect.reload()
    return

  gulp.watch(paths.slim).on "change", (e) ->
    gulp.src(e.path).pipe(slim(pretty: true).on("error", (err) ->
      console.log err
      return
    )).pipe(gulp.dest("./app/views/")).pipe connect.reload()
    return

  return

gulp.task "install", ["git-check"], ->
  bower.commands.install().on "log", (data) ->
    gutil.log "bower", gutil.colors.cyan(data.id), data.message
    return


gulp.task "git-check", (done) ->
  unless sh.which("git")
    console.log "  " + gutil.colors.red("Git is not installed."), "\n  Git, the version control system, is required to download Ionic.", "\n  Download git here:", gutil.colors.cyan("http://git-scm.com/downloads") + ".", "\n  Once git is installed, run '" + gutil.colors.cyan("gulp install") + "' again."
    process.exit 1
  done()
  return

gulp.task "serve", ["slim", "coffee", "sass", "watch"], ->
  connect.server
    livereload: {port: 35728}
    port: 9000
    root: ["./app"]
  return

gulp.task "pre-build", ['slim', 'coffee', 'sass'], ->
  gulp.src('./app/views/*.html').pipe(gulp.dest('./www/views/'))
  return

gulp.task 'concat', ['pre-build'], ->
  files = mainBowerFiles()
  files.push './app/scripts/app.js'
  files.push './app/scripts/controllers/*.js'
  files.push './app/scripts/directives/*.js'
  files.push './app/scripts/services/*.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image-ios.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image-orientation.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image-meta.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image-exif.js'
  files.push './app/bower_components/blueimp-load-image/js/load-image-exif-map.js'
  files.push './app/bower_components/blueimp-canvas-to-blob/js/canvas-to-blob.js'
  files.push './app/bower_components/jquery-file-upload/js/cors/jquery.postmessage-transport.js'
  files.push './app/bower_components/jquery-file-upload/js/cors/jquery.xdr-transport.js'
  files.push './app/bower_components/jquery-file-upload/js/vendor/jquery.ui.widget.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-process.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-validate.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-image.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-audio.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-video.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.fileupload-angular.js'
  files.push './app/bower_components/jquery-file-upload/js/jquery.iframe-transport.js'

  #gulp.src(files).pipe(concat('vendor.js')).pipe(uglify()).pipe(gulp.dest('./www/'))
  gulp.src(files).pipe(concat('vendor.js')).pipe(gulp.dest('./www/'))

  cssfiles = [
    './app/styles/main.css'
    './app/bower_components/jquery-ui/themes/smoothness/jquery-ui.css'
    #'./app/bower_components/jqueryui-timepicker-addon/dist/jquery-ui-timepicker-addon.min.css'
    './app/bower_components/jquery-file-upload/css/jquery.fileupload.css'
  ]
  gulp.src(cssfiles).pipe(concat('main.css')).pipe(minifycss({keepBreaks: true})).pipe(gulp.dest('./www/'))
  gulp.src('./app/cn.json').pipe(gulp.dest('./www/'))
  return

gulp.task 'build', ['concat'], ->
  console.log mainBowerFiles()
