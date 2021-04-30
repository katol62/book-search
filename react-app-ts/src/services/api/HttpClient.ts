import axios, {AxiosError, AxiosInstance, AxiosRequestConfig, AxiosResponse, ResponseType} from "axios";
import {Store} from "redux";
import {IStore} from "../../store/Store";
import {useDispatch, useStore} from "react-redux";
import {IBaseResponse} from "../../interfaces";
import qs from "qs";
import {authActions} from "../../store/actions/authActions";

export enum EMethod {
	GET= 'GET', POST = 'POST', PUT = 'PUT', DELETE = 'DELETE'
}

const contentTypes = {
	json: 'application/json',
	form: 'application/x-www-form-urlencoded',
	multipart: 'multipart/form-data',
};

export interface IData {
	auth?: boolean;
	contentType?: string;
	responseType?: ResponseType;
	payload?: any;
}

const defaultOptions: IData = {
	auth: true,
	contentType: contentTypes.json,
	responseType: 'json',
	payload: null
};

const defaultUrl: string = process.env.REACT_APP_PUBLIC_URL ? `${process.env.REACT_APP_PUBLIC_URL}/api/` : `/api/`;

class HttpClient{
	protected readonly instance: AxiosInstance;
	private rootState: Store<IStore, any> = useStore();
	private dispatch = useDispatch();

	constructor(baseUrl?: string) {
		this.instance = axios.create({
			url: baseUrl ? baseUrl : defaultUrl
		});
		this.initializeResponseInterceptor();
	}

	private initializeResponseInterceptor = () => {
		this.instance.interceptors.response.use(
			this.handleResponse,
			this.handleResponseError,
		);
		this.instance.interceptors.request.use(
			this.handleRequest,
			this.handleError,
		);
	};

	private handleResponse = (response: AxiosResponse) => {
		return response;
	}

	private handleError = (error: any) => {
		Promise.reject(error).then(r => console.log(r));
	}

	private handleResponseError = (error: AxiosError) => {
		if (error.response?.status === 401) {
			this.dispatch(authActions.logout())
		}
		return Promise.reject(error).then(r => console.log(r));
	}

	private handleRequest = (config: AxiosRequestConfig) => {
		const store = this.rootState.getState();
		if (store.auth && store.auth.token) {
			config.headers['Authorization'] = 'Bearer ';
		}
		return config;
	};

	private async request<T extends IBaseResponse>(method: EMethod, endpoint: string, options?: IData): Promise<T> {

		const store = this.rootState.getState();

		let opt = {
			...defaultOptions, ...options
		};
		let data = opt.payload ? opt.payload : null;

		let headers: any = {};
		headers['Content-Type'] = opt.contentType;
		headers['Accept'] = '*/*';

		if (opt.auth && store.auth && store.auth.token) {
			headers['Authorization'] = `Bearer ${store.auth.token}`;
		}

		if (opt.contentType === contentTypes.form) {
			data = qs.stringify(data);
		}

		const axiosOptions: AxiosRequestConfig = {
			method: method,
			url: endpoint,
			headers: headers,
			[method === EMethod.GET ? 'params' : 'data']: data,
			responseType: opt.responseType,
		};

		try {
			const response: AxiosResponse = await this.instance(axiosOptions);
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

}

export const httpClient = new HttpClient();
