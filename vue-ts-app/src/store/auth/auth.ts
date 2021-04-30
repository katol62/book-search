import { VuexModule, Module, Mutation, Action } from 'vuex-module-decorators';
import {IUser} from '@/models/Models';
import {SConstants} from '@/store/Constants';
import StorageService, {CConstants} from '@/services/StorageService';
import router from '@/router';

export interface AuthStore {
    token: string | null;
    user: IUser | null;
}

@Module({
    namespaced: true,
    name: SConstants.AUTH}
    )
export default class Auth extends VuexModule implements AuthStore {
    private storage: StorageService = new StorageService();

    public token: string | null = this.getToken();
    public user: IUser | null = this.getUser();

    @Action
    public login(token: string): void {
        this.context.commit('Auth/setToken', token);
    }

    @Action
    public logout(): void {
        this.context.commit('Auth/setLogout');
    }

    @Mutation
    public setMe(user: IUser): void {
        this.user = user;
        const auth = this.storage.getItem(CConstants.STORE) ? this.storage.getItem(CConstants.STORE) : {};
        this.storage.setItem(CConstants.STORE, {auth: {...auth, user: this.user}});
        router.push('/');
    }

    @Mutation
    private setToken(token: string): void {
        this.token = token;
        const auth = this.storage.getItem(CConstants.STORE) ? this.storage.getItem(CConstants.STORE) : {};
        this.storage.setItem(CConstants.STORE, {auth: {...auth, token: this.token}});
        router.push('/');
    }

    @Mutation
    public setLogout(): void {
        this.token = null;
        this.user = null;
        this.storage.clear();
        router.push('/login');
    }

    private getToken(): string | null {
        return this.storage.getItem(CConstants.STORE) && this.storage.getItem(CConstants.STORE).auth  && this.storage.getItem(CConstants.STORE).auth.token ? this.storage.getItem(CConstants.STORE).auth.token : null;
    }

    private getUser(): IUser | null {
        return this.storage.getItem(CConstants.STORE) && this.storage.getItem(CConstants.STORE).auth  && this.storage.getItem(CConstants.STORE).auth.user ? this.storage.getItem(CConstants.STORE).auth.user : null;
    }

}
