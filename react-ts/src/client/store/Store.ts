import { applyMiddleware, createStore, Store } from 'redux';
import {createBrowserHistory} from 'history';
import {IAuthState} from "../reducers/AuthReducer";
import {routerMiddleware, RouterState} from 'connected-react-router';
import RouteReducer from "../reducers";
import Storage, {Constants} from "./Storage";
import thunkMiddleware from 'redux-thunk';
import {INotificationState} from "../reducers/NotificationReducer";
import {authMiddleWare} from "../helpers/AuthMiddleware";

export interface IStore extends Store<IStore> {
    auth: IAuthState;
    notification: INotificationState;
    router: RouterState;
}

export default class AppStore {

    public store: Store;

    constructor() {
        this.store = this.create();
    }

    private create(): Store<IStore, any> {
        const storage = new Storage();
        const persistentState = storage.getItem(Constants.STORE);
        const history = createBrowserHistory();
        const rootReducer = new RouteReducer(history);
        const middlewares = [
            routerMiddleware(history),
            authMiddleWare,
            thunkMiddleware];

        const s: Store = createStore(
            rootReducer.reducer,
            persistentState ? persistentState : {},
            applyMiddleware(
                ...middlewares
            )
        )
        storage.connect(s);
        return s;
    }
}

