import {Store} from "redux";

export const STORE: string = 'STORE';
export type STORAGE_TYPE = 'session' | 'local';

class Storage {

	private readonly type: STORAGE_TYPE;

	constructor(type?: STORAGE_TYPE) {
		this.type = type ? type : 'session';
	}

	connect(store: Store): void {
		store.subscribe(
			() => {
				this.setItem(STORE, store.getState())
			}
		)
	}

	public getItem(key: string): any {
		const obj = this.type === 'session' ? sessionStorage.getItem(key) : localStorage.getItem(key);
		return obj ? JSON.parse(obj) : null;
	}

	public setItem(key: string, data: any) {
		this.type === 'session' ? sessionStorage.setItem(key, JSON.stringify(data)) : localStorage.setItem(key, JSON.stringify(data));
	}

	public clear() {
		this.type === 'session' ? sessionStorage.clear() : localStorage.clear();
	}

}

export const storage = new Storage();
