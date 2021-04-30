import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {AuthService} from '../../shared/services/auth.service';
import {IAuthResponse} from '../../../../server/interfaces/http-data';
import {Subscription} from 'rxjs';

export abstract class BasicComponent implements OnInit, OnDestroy {

  public authInfo: IAuthResponse;
  protected authSubscriber: Subscription;

  protected router: Router;
  protected authService: AuthService;

  protected constructor( protected injector: Injector) {
    this.router = injector.get(Router);
    this.authService = injector.get(AuthService);
  }

  ngOnInit(): void {
    this.authSubscriber = this.authService.authInfo
      .subscribe((info: IAuthResponse) => {
        this.authInfo = info;
        this.afterInit();
      });
  }

  ngOnDestroy(): void {
    this.authSubscriber.unsubscribe();
    this.authSubscriber = null;
  }

  protected abstract afterInit(): void;

}
