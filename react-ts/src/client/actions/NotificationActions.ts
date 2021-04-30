import {Action} from 'redux';
import {NotificationType} from "../reducers/NotificationReducer";

export enum NotificationActionsType {
    OPEN = 'notify/OPEN',
    CLOSE = 'notify/CLOSE'
}

export interface INotificationAction<T> extends Action<any> {
    type: NotificationActionsType,
    notifyType?: NotificationType,
    message: string | null
}

export default class NotificationActions {

    public open(type: NotificationType, message: string): INotificationAction<any> {
        return {
            type: NotificationActionsType.OPEN,
            notifyType: type,
            message: message
        }
    }

    public close(): INotificationAction<any> {
        return {
            type: NotificationActionsType.CLOSE,
            message: ''
        }
    }
}
