import {IUser} from "../../interfaces";
import {EAuthActionsType, TAuthActions} from "../actions/authActions";

export interface IAuthState {
	token: string | null;
	user: IUser | null;
}

const initialState: IAuthState = {
	token: null,
	user: null
}

export class AuthReducer {
	public static reducer(state: IAuthState = initialState, action: TAuthActions): IAuthState {
		switch (action.type) {
			case EAuthActionsType.LOGIN:
				return {
					...state,
					token: action.payload.data.token
				};
			case EAuthActionsType.LOGOUT:
				return {
					token: null,
					user: null
				};
			case EAuthActionsType.ME:
				return {
					...state,
					user: action.payload.data.user
				};
			default:
				return state;
		}
	}
}

export const authReducer = AuthReducer.reducer;
