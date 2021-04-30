import {action, computed, observable, runInAction} from "mobx";
import RootStore from "./root-store";

export default class SessionStore {

    rootStore: RootStore;

    @observable token = null;
    @observable user = null;

    constructor(
        rootStore
    ) {
        this.rootStore = rootStore;
        this.initSession();
    }

    private initSession() {
        this.token = this.rootStore.storage.getItem('token');
        this.rootStore.apiService.authToken = this.token;
        if (this.token && this.rootStore.router) {
            this.me();
        }
    }

    @computed
    get currentToken(): any {
        return this.token;
    }

    @computed
    get currentUser(): any {
        return this.user;
    }

    @computed
    get isAuthenticated(): boolean {
        return this.token !== null;
    }

    @action
    setToken = (token: any) => {
        this.rootStore.storage.setItem('token', token);
        this.token = token;
        this.rootStore.apiService.authToken = token;
    };

    @action
    setUser = (user) => {
        this.user = user;
        this.rootStore.storage.setItem('user', user);
    };

    @action logout = () => {
        this.rootStore.apiService.authToken = null;
        this.rootStore.storage.clear();
        this.token = null;
        this.user = null;
        this.rootStore.router.history.push('/');
    };

    //api actions
    @action
    login = async (email: string, password: string) => {
        const result = await this.rootStore.apiService.request<any>('post', '/quasarapi/login', {payload: {email: email, password: password}});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                this.logout();
            })
        } else {
            runInAction(() => {
                this.setToken(result.token);
                this.rootStore.router.history.push('/');
                this.me();
            })
        }
    };

    @action
    me = async () => {
        const result = await this.rootStore.apiService.request<any>('post', '/quasarapi/me', {});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                console.log(result.response);
                this.handleError(result.status);
            })
        } else {
            runInAction(() => {
                this.setUser(result.user);
            })
        }
    };

    @action
    handleError = (status) => {
        if (status === 401 || status === 500) {
            this.logout();
        }
    }

}
