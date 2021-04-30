import {AuthActionsType, IAuthAction} from "../actions/AuthActions";
import {IUser} from "../models/User";

export interface IAuthState {
    isAuthenticated: boolean;
    token: string | null;
    user: IUser | null;
}

export const initialAuthState: IAuthState = {
    isAuthenticated: false,
    token: null,
    user: null
}

export default class AuthReducer {

    public static reducer(state: IAuthState = initialAuthState, action: IAuthAction<any>): IAuthState {
        switch (action.type) {
            case AuthActionsType.LOGIN:
                return {
                    ...state,
                    isAuthenticated: true,
                    token: action.payload.data.token
                };
            case AuthActionsType.LOGIN_ERROR:
                return {
                    ...state,
                    isAuthenticated: false,
                    token: null,
                    user: null
                };
            case AuthActionsType.ME:
                return {
                    ...state,
                    isAuthenticated: true,
                    user: action.payload.data.user
                };
            case AuthActionsType.LOGOUT:
                return {
                    ...state,
                    isAuthenticated: false,
                    token: null,
                    user: null
                };
            default:
                return state;
        }
    }
}
