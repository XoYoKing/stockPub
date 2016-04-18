var gulp = require('gulp');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');
var stylish = require('jshint-stylish');
var git = require('gulp-git');
//单元测试
gulp.task('unittest', function() {
    return gulp.src(['test/unitTest/*_test.js'], { read: false })
    .pipe(mocha({
      reporter: 'spec',
      globals: {
        should: require('should')
      }
    }));
});

//语法检查
gulp.task('lint', function() {
    return gulp.src(['./*.js', './utility/*.js', './router/*.js', './databaseOperation/*.js'])
       .pipe(jshint())
       .pipe(jshint.reporter(stylish));
});
