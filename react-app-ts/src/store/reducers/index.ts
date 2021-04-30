import {History, State} from 'history';
import {connectRouter, RouterState} from "connected-react-router";
import {CombinedState, combineReducers, Reducer} from "redux";
import {authReducer, IAuthState} from "./authReducer";
import {createBrowserHistory} from 'history';

class RootReducer {

	public history = createBrowserHistory()

	constructor() {
	}

	public get reducer(): Reducer<CombinedState<{ auth: IAuthState; router: RouterState<State> }>> {
		return combineReducers({
			auth: authReducer,
			router: connectRouter(this.history),
		});
	}
}

export const rootReducer = new RootReducer();
