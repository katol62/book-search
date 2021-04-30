import {Component, OnDestroy, OnInit} from '@angular/core';
import {IAuthResponse} from '../../../server/interfaces/http-data';
import {Subscriber, Subscription} from 'rxjs';
import {AuthService} from '../shared/services/auth.service';
import {loginPath} from '../routes';
import {Router} from '@angular/router';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit, OnDestroy {

  public authInfo: IAuthResponse;
  private authSubscriber: Subscription;

  constructor(
    private router: Router,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.authSubscriber = this.authService.authInfo
      .subscribe((info: IAuthResponse) => {
        this.authInfo = info;
      });
  }

  ngOnDestroy(): void {
    this.authSubscriber.unsubscribe();
    this.authSubscriber = null;
  }

}
