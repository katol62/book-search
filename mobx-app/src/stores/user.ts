import {action, computed, observable, runInAction} from "mobx";
import RootStore from "./root-store";
import { toJS } from 'mobx';

export default class UserStore {

    rootStore: RootStore;

    @observable usersList: any[] = [];
    @observable currentUser: any = null;
    @observable updateId: any = null;
    @observable updated: boolean = false;

    constructor(rootStore) {
        this.rootStore = rootStore;
    }

    @action
    setUser = (user: any) => {
        this.currentUser = user;
        debugger;
    };

    @action
    setUsers = (users) => {
        this.usersList = users;
        this.usersList = toJS(this.usersList);
        console.log(this.usersList);
        console.log(toJS(this.usersList));
    };

    @action
    setId = (id) => {
        this.updateId = id;
    };

    @action
    setUpdated = () => {
        this.updated = true;
    };

    @action
    resetUpdated = () => {
        this.updated = false;
    };

    @action
    getUsers = async () => {
        const result = await this.rootStore.apiService.request<any>('get', '/quasarapi/users', {});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                console.log('status: ' + result.status);
                this.rootStore.session.handleError(result.status);
            })
        } else {
            runInAction(() => {
                this.setUsers(result.users);
            })
        }

    };

    @action
    getUser = async (id) => {
        const result = await this.rootStore.apiService.request<any>('get', `/quasarapi/user/${id}`, {});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                console.log('status: ' + result.status);
                this.rootStore.session.handleError(result.status);
            })
        } else {
            runInAction(() => {
                this.setUser(result.user);
            })
        }
    };

    @action
    resetUser = () => {
        this.currentUser = null;
    };

    @action
    createUser = async (user) => {
        const result = await this.rootStore.apiService.request<any>('post', '/quasarapi/user', {payload: user});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                console.log('status: ' + result.status);
                this.setId(null);
                this.resetUpdated();
                this.rootStore.session.handleError(result.status);
            })
        } else {
            runInAction(() => {
                this.setId(result.insertId);
                this.setUpdated();
            })
        }
    };

    @action
    updateUser = async (user) => {
        const result = await this.rootStore.apiService.request<any>('put', '/quasarapi/user', {payload: user});
        if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
            runInAction(() => {
                console.log('status: ' + result.status);
                this.setId(null);
                this.resetUpdated();
                this.rootStore.session.handleError(result.status);
            })
        } else {
            runInAction(() => {
                debugger;
                this.setId(result.insertId);
                this.setUpdated();
            })
        }
    };

    //returned values
    @computed
    get user(): any {
        return this.currentUser;
    }

    @computed
    get users(): any[] {
        return this.usersList.slice();
    }

    @computed
    get updId(): any {
        return this.updateId;
    }

    @computed
    get isUpdated(): boolean {
        return this.updated;
    }

}
