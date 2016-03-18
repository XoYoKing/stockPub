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

gulp.task('lint', function() {
    return gulp.src('./*.js')
       .pipe(jshint())
       .pipe(jshint.reporter(stylish));
});
