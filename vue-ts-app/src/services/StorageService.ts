export enum CConstants {
    STORE = 'STORE'
}

export type STORAGE_TYPE = 'session' | 'local';

export default class Storage {

    private type: STORAGE_TYPE;

    constructor() {
        this.type = 'session';
    }

    public getItem(key: string): any {
        const obj = sessionStorage.getItem(key);
        return obj ? JSON.parse(obj) : null;
    }

    public setItem(key: string, data: any) {
        sessionStorage.setItem(key, JSON.stringify(data));
    }

    public clear() {
        sessionStorage.clear();
    }

}
