import {Injectable, Injector, OnInit} from '@angular/core';
import {BehaviorSubject, Observable} from 'rxjs';
import {RestService} from './rest.service';
import {IAuthRequest, IAuthResponse} from '../../../../server/interfaces/http-data';
import {IUser} from '../../../../server/models/User';
import {map, tap} from 'rxjs/operators';
import {PersistentStorageService} from './persistent-storage.service';
import * as jwt_decode from 'jwt-decode';

export const STORAGE_KEY_LOGIN = 'authData';

@Injectable()
export class AuthService extends RestService {

  private authData: BehaviorSubject<IAuthResponse>;

  constructor(protected injector: Injector,
              private storage: PersistentStorageService) {
    super(injector);
    this.authData = new BehaviorSubject(this.storage.getItem(STORAGE_KEY_LOGIN));
  }

  public get authInfo(): Observable<IAuthResponse> {
    return this.authData.asObservable();
  }

  public get token(): string {
    const value: IAuthResponse = this.authData.value;
    return value == null ? null : (this.isTokenExpired(value.token) ? null : value.token);
  }
  public get user(): IUser {
    const value: IAuthResponse = this.authData.value;
    return value == null ? null : value.user;
  }

  public login(req: IAuthRequest): Observable<IAuthResponse> {
    return this.postForm('auth', req)
      .pipe(
        map((result: IAuthResponse) => this.setLoginToStorage(result)),
        tap((result: IAuthResponse) => {
          this.afterLogin();
          this.authData.next(result);
        })
      );
  }

  public onLogout(): void {
    this.authData.complete();
    this.authData = new BehaviorSubject(null);
    this.storage.removeItem(STORAGE_KEY_LOGIN);
  }

  private afterLogin(): void {
  }

  private setLoginToStorage(result: IAuthResponse): IAuthResponse {
    this.storage.setItem(STORAGE_KEY_LOGIN, result);
    return result;
  }

  getTokenExpirationDate(token: string): Date {
    const decoded = jwt_decode(token);
    if (decoded.exp === undefined) { return null; }

    const date = new Date(0);
    date.setUTCSeconds(decoded.exp);
    return date;
  }

  isTokenExpired(token?: string): boolean {
    if (!token) { token = this.token; }
    if (!token) { return true; }
    debugger;
    const date = this.getTokenExpirationDate(token);
    if (date === undefined) { return false; }
    return !(date.valueOf() > new Date().valueOf());
  }

  get role(): string {
    const token = this.token;
    if (!token) { return null; }
    const decoded = jwt_decode(token);
    return decoded.role ? decoded.role : null;
  }

}

