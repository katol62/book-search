import {StorageService, StorageType} from "../services/storage.service";
import {Injector} from "@angular/core";
import {Subscription} from "rxjs";

export const check = (raw: string) => {
    try {
        return JSON.parse(raw);
    } catch (err) {
        return false;
    }
}
export function isSubscription(val: any): val is Subscription {
    return !!val && (val instanceof Subscription || (typeof val.unsubscribe === 'function'))
}

const injector = Injector.create([{provide: StorageService, useClass: StorageService}]);

export function Storage<Type>(key: string, storageType: StorageType = StorageType.Session, defaultValue: Type = null): Function {
    return function (target: object, propName: string) {
        let _val: Type = target[propName];
        const storage = injector.get(StorageService);
        storage.storageType = storageType;
        Object.defineProperty(
            target,
            propName,
            {
                get(): Type | undefined {
                    if (_val !== null && _val !== undefined) {
                        return _val;
                    }
                    const i = storage.getItem(key);
                    let item = check(i) ? JSON.parse(i) : i;
                    if (item === null) {
                        item = typeof (defaultValue) === 'string' ? defaultValue : JSON.stringify(defaultValue);
                        _val = defaultValue;
                        storage.setItem(key, item);
                    }
                    return item;
                },
                set(item: Type): void {
                    _val = item;
                    if (typeof (item) === 'string' && item === '') {
                        storage.removeItem(key);
                    } else {
                        storage.setItem(key, typeof (item) === 'string' ? item : JSON.stringify(item));
                    }
                }
            }
        )
    }
}

export function Unsubscribe(): ClassDecorator {
    return function ( constructor: Function ) {
        const original = constructor.prototype.ngOnDestroy;
        // if (!original || !(typeof original === 'function')) {
        //   throw new Error('no ngOnDestroy');
        // }
        constructor.prototype.ngOnDestroy = function() {
            original && original.apply(this, arguments);
            for (let propName in this) {
                const property = this[propName];
                if (isSubscription(property)) {
                    property.unsubscribe();
                }
            }
        }
    }
}
