import {AnyAction, applyMiddleware, createStore, Store} from "redux";
import {IAuthState} from "./reducers/authReducer";
import {routerMiddleware, RouterState} from 'connected-react-router';
import {storage, STORE} from "./storage/Storage";
import thunkMiddleware from 'redux-thunk';
import {rootReducer} from "./reducers";

export interface IStore extends Store<IStore> {
	auth: IAuthState;
	router: RouterState;
}

class AppStore {
	public store: Store;

	constructor() {
		this.store = this.create();
	}

	private create(): Store<IStore, AnyAction> {

		const persistentState = storage.getItem(STORE);
		const history = rootReducer.history;

		const middlewares = [
			routerMiddleware(history),
			thunkMiddleware];

		const store: Store = createStore(
			rootReducer.reducer,
			persistentState ? persistentState : {},
			applyMiddleware(
				...middlewares
			)
		)
		storage.connect(store);
		return store;
	}
}
