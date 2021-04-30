<template>
    <b-container></b-container>
</template>

<script lang="ts">
  import { Component, Vue, Watch } from 'vue-property-decorator';
  import {getModule} from 'vuex-module-decorators';
  import NotificationModule, {INotification} from '@/store/notification/NotificationModule';

  @Component({
    name: 'user-notification'
  })
  export default class UserNotification extends Vue {
    public noticationInstance: NotificationModule = getModule(NotificationModule);

    @Watch('noticationInstance.notification')
    public onPropertyChange(notification: INotification, oldValue: string) {
      // create a toast
      const message = notification.message || '';
      this.$bvToast.toast(message, {
        title: notification.prompt || 'Info',
        variant: notification.variant || 'warning',
        solid: true
      });

    }
  }
</script>

<style scoped>

</style>
