import {IUser} from "./User";

export interface IPaging {
    offset: number;
    limit: number;
}

export interface IBaseRequest {
    id?: number;
    paging?: IPaging;
    filter?: any;
}

export interface IBaseResponse {
    error?: Error;
    message?: string;
    success: boolean;
    data?: any;
}

export interface IAuthRequest extends IBaseRequest{
    email?: string;
    password?: string;
    softcode?: string;
    type?: 'super' | 'admin' | 'cashier' | 'customer' | 'partner';
}

export interface IAuthResponse extends IBaseResponse{
    token?: string;
    user?: IUser;
}
