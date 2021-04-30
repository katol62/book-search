import {RouterStore} from "mobx-react-router";
import SessionStore from "./session";
import UserStore from "./user";
import {ApiService} from "../services/api-service";
import PesistentStorage from "../services/persistent-storage";


export default class RootStore {

    router: RouterStore;
    session: SessionStore;
    user: UserStore;
    apiService: ApiService;
    storage: PesistentStorage;

    constructor(router) {
        this.router = router;
        this.storage = new PesistentStorage();
        this.apiService = new ApiService();
        this.session = new SessionStore(this);
        this.user = new UserStore(this);
    }

}
