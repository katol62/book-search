import { Action, ActionCreator, Dispatch } from 'redux'
import {IBaseResponse, IUser} from "../../interfaces";

export enum EAuthActionsType {
	LOGIN = 'auth/LOGIN',
	LOGIN_ERROR = 'auth/LOGIN_ERROR',
	LOGOUT = 'auth/LOGOUT',
	ME = 'auth/ME',
}

export interface IAuthLoginAction extends Action<EAuthActionsType.LOGIN> {
	payload: IBaseResponse
}

export interface IAuthLogoutAction extends Action<EAuthActionsType.LOGOUT> {}

export interface IAuthMeAction extends Action<EAuthActionsType.ME> {
	payload: IBaseResponse
}

export type TAuthActions = IAuthLoginAction | IAuthLogoutAction | IAuthMeAction;

class AuthActions {

	public login(payload: IBaseResponse): TAuthActions {
		return {
			type: EAuthActionsType.LOGIN,
			payload: payload
		} as IAuthLoginAction
	}

	public logout(): TAuthActions {
		return {
			type: EAuthActionsType.LOGOUT
		} as IAuthLogoutAction
	}

	public me(payload: IBaseResponse): TAuthActions {
		return {
			type: EAuthActionsType.ME,
			payload: payload
		}
	}
}

export const authActions = new AuthActions();
