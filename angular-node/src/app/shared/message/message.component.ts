import {Component, NgZone, OnDestroy, OnInit} from '@angular/core';
import {MatSnackBar, MatSnackBarConfig, MatSnackBarRef} from '@angular/material/snack-bar';
import {IMessageItem, NotificationMessageType, NotificationService} from '../services/notification.service';
import {Subscription} from 'rxjs';

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styleUrls: ['./message.component.scss']
})
export class MessageComponent implements OnInit, OnDestroy{

  private subscription: Subscription;
  private snackBarConfig: MatSnackBarConfig;
  private snackBarAutoHide = 5000;

  constructor(private notificationService: NotificationService,
              private zone: NgZone,
              private snackBar: MatSnackBar) {
  }

  openMessage(message: IMessageItem): void {
    this.snackBarConfig = new MatSnackBarConfig<any>();
    this.snackBarConfig.duration = this.snackBarAutoHide;
    this.snackBarConfig.verticalPosition = 'top';
    this.snackBarConfig.panelClass = [message.messageType];
    this.snackBar.open(message.message, message.messageType, this.snackBarConfig);
  }

  ngOnInit(): void {
    this.subscription = this.notificationService.notification$.subscribe((message: IMessageItem) => {
      this.zone.run( () => {
          this.openMessage(message);
        }
      );
    });
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }


}
