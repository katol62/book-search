import {observable} from "mobx";

export default class User {

    @observable first_name: string = '';
    @observable last_name: string = '';
    @observable email: string = '';
    @observable password: string = '';
    @observable role: string = '';

    constructor(user?: any) {
        this.first_name = user && user.first_name ? user.first_name : '';
        this.last_name = user && user.last_name ? user.last_name : '';
        this.email = user && user.email ? user.email : '';
        this.password = user && user.password ? user.password : '';
        this.role = user && user.role ? user.role : '';
    }
}
