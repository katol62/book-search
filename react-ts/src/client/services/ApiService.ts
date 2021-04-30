import axios, {AxiosInstance, AxiosResponse} from 'axios';
import {Store} from 'redux';
import {IStore} from "../store/Store";
import {useDispatch, useStore} from "react-redux";
import NotificationService from "./NotificationService";
import AuthActions from "../actions/AuthActions";
import {NotificationType} from "../reducers/NotificationReducer";

export interface IBaseRequest {
    id?: number;
    filter?: any;
}

export interface IBaseResponse {
    error?: Error;
    message?: string;
    success: boolean;
    data?: any;
}

export const contentTypes = {
    json: 'application/json',
    form: 'application/x-www-form-urlencoded',
    multipart: 'multipart/form-data',
};

export enum EMethod {
    GET= 'GET', POST = 'POST', PUT = 'PUT', DELETE = 'DELETE'
}

export interface Interface {

}

export default class ApiService {
    private baseUrl = '';
    private readonly axiosInstance: AxiosInstance;
    private rootState: Store<IStore, any> = useStore();
    private notificationService: NotificationService = NotificationService.instance;
    private dispatch = useDispatch();
    private authActions: AuthActions;

    constructor() {
        this.authActions = new AuthActions();
        this.axiosInstance = axios;

        this.axiosInstance.interceptors.response.use(
            (response: AxiosResponse) => {
                return response;
            }, (error: any) => {
                const mess = error.message ? error.message : 'Server error';
                this.notificationService.open(NotificationType.error, mess);
                if (error.response.status === 500) {
                }
                else if (error.response.status === 401) {
                    this.dispatch(this.authActions.logOut());
                } else {
                    return Promise.reject(error);
                }

            }
        );

    }

    private defaultOptions = {
        auth: true,
        contentType: contentTypes.json,
        responseType: 'json',
        payload: null
    };

    private async request<T extends IBaseResponse>(method: EMethod, endpoint: string, options?: any): Promise<T> {

        const store = this.rootState.getState();

        let opt = {
            ...this.defaultOptions, ...options
        };
        let data = opt.payload ? opt.payload : null;

        let headers: any = {};
        headers['Content-Type'] = opt.contentType;
        headers['Accept'] = '*/*';

        if (opt.auth && store.auth && store.auth.token) {
            headers['x-access-token'] = `${store.auth.token}`;
        }

        if (opt.contentType === contentTypes.form) {
            data = this.stringifyForm(data);
        }

        const url = this.baseUrl + endpoint;

        const axiosOptions = {
            method: method,
            url: url,
            headers: headers,
            [method === EMethod.GET ? 'params' : 'data']: data,
            responseType: opt.responseType,
        };

        try {
            const response: AxiosResponse = await this.axiosInstance(axiosOptions);
            if (response && response.data) {
                return response.data;
            } else {
                const resp = {
                    success: false
                } as T;
                return resp as T;
            }
        } catch (e) {
            return e.response ? e.response : e;
        }

    }

    public async GET<T extends IBaseResponse>(endpoint: string, options?: any): Promise<T> {
        return this.request(EMethod.GET, endpoint, options);
    }

    public POST<T extends IBaseResponse>(endpoint: string, options?: any): Promise<T> {
        return this.request(EMethod.POST, endpoint, options);
    }

    public async PUT<T extends IBaseResponse>(endpoint: string, options?: any): Promise<T> {
        return this.request(EMethod.POST, endpoint, options);
    }

    private stringifyForm(form: any): string {
        return Object.keys(form)
            .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(form[k])}`)
            .join('&');
    };


}
