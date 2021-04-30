import {RouteConfig} from 'vue-router';

const routes: RouteConfig[] = [
    {
        path: '/login',
        name: 'login',
        component: () => import('@/views/pages/Login.vue'),
    },
    {
        path: '/',
        component: () => import('../views/layouts/Dashboard.vue'),
        children: [
            { path: '',
                component: () => import('../views/pages/Home.vue'),
                meta: {
                    requiresAuth: true,
                    permissions: ['admin', 'user', 'customer']
                }
            },
            { path: 'users',
                component: () => import('../views/pages/Users.vue'),
                meta: {
                    requiresAuth: true,
                    permissions: ['admin', 'user'],
                }
            },
        ]
    },
    {
        path: '/not-authorized',
        name: 'not-authorized',
        component: () => import('../views/pages/Login.vue'),
    }
];

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
    routes.push({
        path: '*',
        component: () => import('../views/pages/Page404.vue')
    });
}

export default routes;
