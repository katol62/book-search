import { Injectable } from '@angular/core';
import {BehaviorSubject} from "rxjs";
import {AlertConfig} from "ngx-bootstrap/alert";

export enum EAlertType {
    SUCCESS = 'success',
    INFO = 'info',
    WARNING = 'warning',
    DANGER = 'danger'
}

export interface IConfig extends AlertConfig {
    heading?: string,
    message?: string,
    isOpen?: boolean;
}

const initialConfig: IConfig = {
    type: EAlertType.INFO,
    dismissible: true,
    isOpen: false,
    dismissOnTimeout: 3000
}

@Injectable()
export class AlertService {

    private alertSubject: BehaviorSubject<Partial<IConfig>> = new BehaviorSubject<Partial<IConfig>>(initialConfig);
    public readonly alert$ = this.alertSubject.asObservable();

    constructor() { }

    public show(alert: Partial<IConfig>): void {
        this.alertSubject.next({...initialConfig, ...alert, isOpen: true});
    }

    public hide(alert: Partial<IConfig>): void {
        this.alertSubject.next({...initialConfig, ...alert, isOpen: false});
    }

}
