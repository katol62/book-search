module.exports = {
    css: {
        loaderOptions: {
            sass: {
                prependData: `@import "@/styles/style.scss";`
            }
        }
    },
    devServer: {
        proxy: {
            '^/api': {
                target: 'http://localhost:3000',
                changeOrigin: true,
                logLevel: "debug"
            },
        }
    }
};
