import { Injectable } from '@angular/core';
import {StorageType} from "../misc/decorators.hoc";

@Injectable({
  providedIn: 'root'
})
export class StorageService {

    private type: StorageType = StorageType.Session;

    storage = {
        Local: localStorage,
        Session: sessionStorage
    };

    constructor() { }

    set storageType(type:StorageType) {
        this.type = type;
    }

    hasItem(type: string): boolean {
        return this.storage[this.type].getItem(type) !== null;
    }

    setItem(type: string, data: any) {
        const isString = typeof (data) === 'string';
        this.storage[this.type].setItem(type, isString ? data : JSON.stringify(data));
    }

    getItem(type: string): any {
        let result = null;
        if (this.hasItem(type)) {
            const item = this.storage[this.type].getItem(type);
            result = this.parse(item) ? JSON.parse(item) : item;
        }
        return result;
    }

    removeItem(type: string) {
        this.storage[this.type].removeItem(type);
    }

    clear() {
        this.storage[this.type].clear();
    }

    setType(t: StorageType) {
        this.type = t;
    }

    getType(): StorageType {
        return this.type;
    }

    private parse(raw: string): any {
        try {
            return JSON.parse(raw);
        } catch (err) {
            return false;
        }
    }

    //

    hasItemFor(storageType: string, type: string): boolean {
        return this.storage[storageType].getItem(type) !== null;
    }

    setItemTo(storageType: string, type: string, data: any) {
        const isString = typeof (data) === 'string';
        this.storage[storageType].setItem(type, isString ? data : JSON.stringify(data));
    }

    getItemFrom(storageType: string, type: string): any {
        let result = null;
        if (this.hasItemFor(storageType, type)) {
            const item = this.storage[storageType].getItem(type);
            result = this.parse(item) ? JSON.parse(item) : item;
        }
        return result;
    }

    removeItemFrom(storageType: string, type: string) {
        this.storage[storageType].removeItem(type);
    }

    clearFrom(storageType: string) {
        this.storage[storageType].clear();
    }

}
