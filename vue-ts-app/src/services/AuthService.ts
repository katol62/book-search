import RestService from '@/services/RestService';
import {Action} from 'vuex-module-decorators';
import store from '@/store';

export default class AuthService {

    protected static inst: AuthService;
    protected rest: RestService;
    protected store = store;

    constructor() {
        this.rest = new RestService();
    }

    public static get instance(): AuthService {
        if (!this.inst) {
            this.inst = new AuthService();
        }
        return this.inst;
    }

    public async login(email: string, password: string): Promise<any> {
        try {
            const result = await this.rest.POST<any>('/api/auth', {payload: {email, password}});
            debugger;
            this.store.commit('Auth/setToken', result.data.token);
        } catch (e) {
            this.store.commit('Auth/setLogout');
        }
    }

    @Action
    public async me(): Promise<any> {
        try {
            const result = await this.rest.POST<any>('/api/me');
            this.store.commit('setMe', result.data.user);
        } catch (e) {
            console.log(e);
        }
    }

}
