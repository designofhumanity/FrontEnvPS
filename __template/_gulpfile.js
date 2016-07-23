var gulp = require('gulp'),
    browserSync = require('browser-sync'); //Подключаем Browser Sync
gulp.task('browser-sync', function() { // Создаем таскbrowser-sync
    browserSync({ // Выполняем browser Sync
        server: { // Определяем параметры сервера
            baseDir: '.' // Директория для сервера- app
        },
        notify: false // Отключаем уведомления
    });
});
gulp.task('watch', ['browser-sync' /*,'sass'*/ ], function() {
    //gulp.watch('app/**/*.html',['sass']);
    // gulp.watch('app/sass/**/*.sass', ['sass']);
    gulp.watch('*.html').on('change', browserSync.reload);
    gulp.watch('/../*.css').on('change', browserSync.reload);
    // gulp.watch('/../*.js').on('change', browserSync.reload);
});
