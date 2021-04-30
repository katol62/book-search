import * as proxy from 'http-proxy-middleware';

export default function(app) {
    app.use(
        '/quasarapi/*',
        proxy('/api', {
            target: 'http://[::1]:8888',
            changeOrigin: true,
            secure: false
        })
    )
};
