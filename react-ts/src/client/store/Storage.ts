import {Store} from 'redux';
import throttle from 'lodash/throttle';

export enum Constants {
    STORE = 'STORE'
}

export type STORAGE_TYPE = 'session' | 'local'

export default class Storage {

    private type: STORAGE_TYPE;

    constructor() {
        this.type = 'session';
    }

    connect(store: Store): void {
        store.subscribe(
            throttle( () => {
                this.setItem(Constants.STORE, {auth: store.getState().auth});
            })
        )
    }

    getItem(key: string): any {
        const obj = sessionStorage.getItem(key);
        return obj ? JSON.parse(obj) : null;
    }

    setItem(key: string, data: any) {
        sessionStorage.setItem(key, JSON.stringify(data))
    }

    clear() {
        sessionStorage.clear();
    }

}
