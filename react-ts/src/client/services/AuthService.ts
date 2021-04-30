import ApiService from "./ApiService";
import AuthActions from "../actions/AuthActions";
import {useDispatch} from "react-redux";
import {push} from "connected-react-router";

export default class AuthService {

    private static _instance: AuthService;
    private api: ApiService;
    private authActions: AuthActions;
    private dispatch = useDispatch()

    constructor() {
        this.api = new ApiService();
        this.authActions = new AuthActions();
    }

    public static get instance(): AuthService {
        if (!this._instance) {
            this._instance = new AuthService();
        }
        return this._instance;
    }

    public async login( email: string, password: string ): Promise<any> {
        try {
            const result = await this.api.POST('/api/auth', {payload: {email: email, password: password}});
            if (!result.success) {
                return;
            }
            this.dispatch(this.authActions.login(result));
            this.dispatch(push('/'));
            this.me();
        } catch (e) {
            this.dispatch(this.authActions.logOut());
        }
    }

    public async me(): Promise<any> {
        try {
            const result = await this.api.POST('/api/me');
            this.dispatch(this.authActions.me(result));
        } catch (e) {
            console.log(e);
        }
    }

    public logout(): void {
        this.dispatch(this.authActions.logOut());
        this.dispatch(push('/login'));
    }

}
