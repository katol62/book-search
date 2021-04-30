import store from "../helpers/store";
import * as axios from 'axios';

const baseUrl = '';

// const extractKey = (o, k) => { const v = o[k]; delete o[k]; return v; };
//
// const constructUrl = (url, payload) =>
//     payload
//         ? url.split('/').map(e => e[0] === ':' && e.length > 1 ? extractKey(payload, e.substr(1)) : e).join('/')
//         : url;

export class ApiResponseError extends Error {
    constructor(status, data) {
        super();
        this.status = status;
        this.data = data;
    }
}

const defaultOptions = {
    auth: true,
    contentType: 'application/json',
    responseType: 'json',
    payload: null
};

const contentTypes = {
    json: 'application/json',
    form: 'application/x-www-form-urlencoded',
    multipart: 'multipart/form-data',
};

export const stringifyForm = (form) =>
    Object.entries(form)
        .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
        .join('&');

export const apiService = () => {

    const create = (method, endpoint, options = {}) => {

        const session = store.getState().session;
        let authToken = session ? session.token : null;

        const opt = {
            ...defaultOptions, ...options
        };

        opt.auth = options.auth ? options.auth : opt.auth;

        // const url = constructUrl(baseUrl, endpoint);
        const url = baseUrl + endpoint;

        let data = opt.payload ? opt.payload : null;
        const headers = {};
        headers['Content-Type'] = opt.contentType;
        headers['Accept'] = '*/*';

        if (opt.auth && authToken) {
            headers['Authorization'] = `Bearer ${authToken}`;
        }

        if (opt.contentType === 'application/x-www-form-urlencoded') {
            data = stringifyForm(data);
        }

        const request = async () => {
            const axiosOptions = {
                method: method,
                url: url,
                headers: headers,
                [method === 'get' ? 'params' : 'data']: data,
                // params: data ? JSON.stringify(data) : undefined,
                responseType: opt.responseType,
            };

            try {
                return await axios(axiosOptions);
            } catch (e) {
                console.log(e);
                const error = e !== undefined ? e : {response: {status: 404, data: 'Not found'}};
                return new ApiResponseError(
                    error.response.status,
                    error.response.data,
                );
            }
        };
        return request()
    };

    return {
        create,
        GET: create.bind(null, 'get'),
        POST: create.bind(null, 'post'),
        PUT: create.bind(null, 'put'),
        PATCH: create.bind(null, 'patch'),
        DELETE: create.bind(null, 'delete')
    }
};
