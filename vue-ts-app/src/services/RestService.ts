import axios, {AxiosInstance, AxiosResponse} from 'axios';
import store from '@/store';
import router from '@/router';
import NotificationModule, {IMessage} from '@/store/notification/NotificationModule';
import {getModule} from 'vuex-module-decorators';

export const contentTypes = {
    json: 'application/json',
    form: 'application/x-www-form-urlencoded',
    multipart: 'multipart/form-data',
};

export enum EMethod {
    GET= 'GET', POST = 'POST', PUT = 'PUT', DELETE = 'DELETE'
}

export default class RestService {
    private baseUrl = '';
    private axiosInstance: AxiosInstance;
    private rootState = store;

    private noticationInstance: NotificationModule = getModule(NotificationModule);

    constructor() {
        this.axiosInstance = axios;
        this.axiosInstance.interceptors.response.use(
            (response: AxiosResponse) => {
                return response;
            }, (error: any) => {
                const mess = error.message ? error.message : 'Server error';
                const message: IMessage = {
                    variant: 'danger',
                    prompt: 'Error',
                    message: mess
                };
                this.noticationInstance.notify(message);
                if (error.response.status === 401) {
                    store.commit('Auth/setLogout');
                    router.push({ name: 'login' });
                } else {
                    return Promise.reject(error);
                }

            }
        );
    }

    public async GET<T>(endpoint: string, options?: any): Promise<T> {
        return await this.request(EMethod.GET, endpoint, options);
    }

    public async POST<T>(endpoint: string, options?: any): Promise<T> {
        return await this.request(EMethod.POST, endpoint, options);
    }

    public async PUT<T>(endpoint: string, options?: any): Promise<T> {
        return await this.request(EMethod.POST, endpoint, options);
    }

    private defaultOptions = {
        auth: true,
        contentType: contentTypes.json,
        responseType: 'json',
        payload: null
    };

    private async request<T>(method: EMethod, endpoint: string, options?: any): Promise<T> {

        const opt = {
            ...this.defaultOptions, ...options
        };
        let data = opt.payload ? opt.payload : null;

        const headers: any = {};
        headers['Content-Type'] = opt.contentType;
        headers['Accept'] = '*/*';

        if (opt.auth && this.rootState.state.Auth && this.rootState.state.Auth.token) {
            headers['x-access-token'] = `${store.state.Auth.token}`;
        }

        if (opt.contentType === contentTypes.form) {
            data = this.stringifyForm(data);
        }

        const url = this.baseUrl + endpoint;

        const axiosOptions = {
            method,
            url,
            headers,
            [method === EMethod.GET ? 'params' : 'data']: data,
            responseType: opt.responseType,
        };

        try {
            const response = await this.axiosInstance(axiosOptions);
            const data = await response.data;
            return data;
        } catch (e) {
            return e.response ? e.response : e;
        }

    }

    private stringifyForm(form: any): string {
        return Object.keys(form)
            .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(form[k])}`)
            .join('&');
    }


}
