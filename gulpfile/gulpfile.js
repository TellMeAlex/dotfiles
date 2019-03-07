// Load plugins
const gulp = require('gulp');

// import tasks
const img = require('./gulp/images.js');
const js = require('./gulp/scripts.js');
const server = require('./gulp/browsersync.js');
const css = require('./gulp/styles.js');
const fonts = require('./gulp/fonts.js');
const clean = require('./gulp/clean.js');

function html() {
  return gulp.src('./src/**/*.html').pipe(gulp.dest('./dist/'));
}

// Watch files
function watchFiles() {
  gulp.watch('./src/scss/**/*', css.build);
  gulp.watch('./src/js/**/*', scripts);
  gulp.watch('./src/**/*', html);
  gulp.watch('./src/assets/img/**/*', gulp.parallel(img.copy, img.resize));
  gulp.watch('./src/assets/fonts/**/*', fonts.copy);
}

// define complex tasks
const scripts = gulp.series(js.lint, js.build);
const images = gulp.series(img.optimise, gulp.parallel(img.copy, img.resize));
const watch = gulp.parallel(watchFiles, server.init);
const build = gulp.series(
  clean.all,
  gulp.parallel(fonts.copy, css.build, images, scripts, html)
);

// expose tasks to CLI
exports.build = build;
exports.watch = watch;
exports.default = build;
