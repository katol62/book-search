import {History, LocationState} from 'history';
import { combineReducers, Reducer, CombinedState } from 'redux'
import AuthReducer, {IAuthState} from "./AuthReducer";
import {connectRouter, RouterState} from 'connected-react-router';
import NotificationReducer, {INotificationState} from "./NotificationReducer";

export default class RouteReducer {

    constructor(public history: History<LocationState>) {
        this.history = history;
    }

    public get reducer(): Reducer<CombinedState<{ auth: IAuthState; notification: INotificationState; router: RouterState<LocationState> }>> {
        return combineReducers({
            auth: AuthReducer.reducer,
            notification: NotificationReducer.reducer,
            router: connectRouter(this.history),
        });
    }
}


