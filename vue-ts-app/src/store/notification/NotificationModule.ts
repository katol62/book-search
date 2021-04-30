import {Module, VuexModule, Mutation, Action} from 'vuex-module-decorators';
import store from '@/store';

export interface INotification {
    variant?: NotificationType;
    prompt?: string;
    message?: string;
}

export interface IMessage {
    variant?: NotificationType;
    prompt?: string;
    message?: string;
}
export type NotificationType = 'info' | 'success' | 'warning' | 'danger';

@Module({
    dynamic: true,
    store,
    name: 'notification',
    namespaced: true,
})
export default class NotificationModule extends VuexModule {

    private notification: INotification = {
        variant: 'info',
        message: ''
    };

    public get getNotification(): INotification {
        return this.notification;
    }

    @Action
    public notify( msg: IMessage ): void {
        debugger;
        const notification = {
            variant: msg.variant || 'info',
            prompt: msg.prompt || 'Info',
            message: msg.message || 'No message provided.'
        };
        this.context.commit('setNotification', notification);
    }

    @Mutation
    public setNotification( data: INotification ): void {
        if (data) {
            this.notification = data;
        }
    }
}
