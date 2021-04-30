import {Dispatch, Middleware, MiddlewareAPI} from "redux";
import {LOCATION_CHANGE, push, RouterAction} from "connected-react-router";
import {unauthorized} from "./Routes";

export const authMiddleWare: Middleware = (store: MiddlewareAPI<any>) => (next: Dispatch<RouterAction>) => (action: RouterAction) => {
    if (action.type === LOCATION_CHANGE) {
        const path = action.payload.location.pathname;
        console.log(path);
        const unauthorizedPage = unauthorized.find(r => r.path === path);
        if (!unauthorizedPage) {
            if (!store.getState().auth.token) {
                store.dispatch(push('/login'));
            }
        } else {
            if (store.getState().auth.token) {
                store.dispatch(push('/'));
            }
        }
    }
    return next(action);
}
