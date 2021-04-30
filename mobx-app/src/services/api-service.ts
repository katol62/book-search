import axios from 'axios';
// import {useStore} from "../helpers/useStore";

export class ApiService {

    private baseUrl = '';
    authToken: any;

    private defaultOptions = {
        auth: true,
        contentType: 'application/json',
        responseType: 'json',
        payload: null
    };

    contentTypes = {
        json: 'application/json',
        form: 'application/x-www-form-urlencoded',
        multipart: 'multipart/form-data',
    };

    private stringifyForm = (form) => {
        Object.keys(form)
            .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(form[k])}`)
            .join('&');
    };

    request = async <T>(method, endpoint, options): Promise<T> => {

        let opt = {
            ...this.defaultOptions, ...options
        };
        let data = opt.payload ? opt.payload : null;

        let headers = {};
        headers['Content-Type'] = opt.contentType;
        headers['Accept'] = '*/*';

        if (opt.auth && this.authToken) {
            headers['Authorization'] = `Bearer ${this.authToken}`;
        }

        if (opt.contentType === 'application/x-www-form-urlencoded') {
            data = this.stringifyForm(data);
        }

        const url = this.baseUrl + endpoint;

        const axiosOptions = {
            method: method,
            url: url,
            headers: headers,
            [method === 'get' ? 'params' : 'data']: data,
            responseType: opt.responseType,
        };

        try {
            const response = await axios(axiosOptions);
            const data = await response.data;
            return data;
        } catch (e) {
            return e.response ? e.response : e;
        }

    }

}
