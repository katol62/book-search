import { Action } from 'redux';

export enum AuthActionsType {
    LOGIN = 'auth/LOGIN',
    LOGIN_SUCCESS = 'auth/LOGIN_SUCCESS',
    LOGIN_ERROR = 'auth/LOGIN_ERROR',
    LOGOUT = 'auth/LOGOUT',
    ME = 'auth/ME',
}

export interface IAuthAction<T> extends Action<any> {
    type: AuthActionsType;
    payload?: any;
}

export default class AuthActions {

    public login(payload: any): IAuthAction<any> {
        return {
            type: AuthActionsType.LOGIN,
            payload: payload
        } as IAuthAction<any>
    }

    public logOut(): IAuthAction<any> {
        return {
            type: AuthActionsType.LOGOUT,
        } as IAuthAction<any>
    }

    public me(payload: any): IAuthAction<any> {
        return {
            type: AuthActionsType.ME,
            payload: payload
        } as IAuthAction<any>
    }

}
