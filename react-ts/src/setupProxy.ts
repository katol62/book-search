import { createProxyMiddleware, Filter, Options, RequestHandler } from 'http-proxy-middleware';

export default (app: any) => {
    app.use(
        '/api/*',
        createProxyMiddleware('/api', {
            target: 'http://localhost:3000',
            changeOrigin: true,
            secure: false
        })
    )
};
