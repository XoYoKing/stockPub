var gulp = require('gulp');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');
var stylish = require('jshint-stylish');

gulp.task('default', function() {
    return gulp.src(['test/unitTest/*_test.js'], { read: false })
    .pipe(mocha({
      reporter: 'spec',
      globals: {
        should: require('should')
      }
    }));
});
sss
gulp.task('lint', function() {
    return gulp.src(['./*.js', './utility/*.js', './router/*.js', './databaseOperation/*.js'])
       .pipe(jshint())
       .pipe(jshint.reporter(stylish));
});
