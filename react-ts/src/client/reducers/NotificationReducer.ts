import {INotificationAction, NotificationActionsType} from '../actions/NotificationActions';

export enum NotificationType {
    info = 'info', success = 'success', warning = 'warning', error = 'error'
}


export interface INotificationState {
    open: boolean;
    type?: NotificationType;
    message: string | null;
}

export const initialState: INotificationState = {
    open: false,
    type: NotificationType.info,
    message: ''
}


export default class NotificationReducer {

    public static reducer( state: INotificationState = initialState, action: INotificationAction<any> ): INotificationState {
        switch (action.type) {
            case NotificationActionsType.OPEN:
                return {
                    ...state,
                    open: true,
                    type: action.notifyType,
                    message: action.message
                }
            case NotificationActionsType.CLOSE:
                return {
                    ...state,
                    open: false,
                    message: null
                }
            default:
                return state
        }
    }
}
