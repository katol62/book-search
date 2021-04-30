import {useDispatch} from "react-redux";
import NotificationActions from "../actions/NotificationActions";
import {NotificationType} from "../reducers/NotificationReducer";

export default class NotificationService {
    private static _instance: NotificationService;
    private dispatch = useDispatch()
    private actions: NotificationActions;

    public static get instance(): NotificationService {
        if (!this._instance) {
            this._instance = new NotificationService();
        }
        return this._instance;
    }

    constructor() {
        this.actions = new NotificationActions();
    }

    public open(type: NotificationType, message: string): void {
        this.dispatch(this.actions.open(type, message));
    }

    public close(): void {
        this.dispatch(this.actions.close());
    }
}
