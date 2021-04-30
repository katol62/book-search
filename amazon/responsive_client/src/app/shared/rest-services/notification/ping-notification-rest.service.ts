import {Injectable} from '@angular/core';
import {environment} from '../../../../environments/environment';
import {BehaviorSubject, Observable, Subject, Subscription} from 'rxjs';
import {PingRequest, PingResponse} from '../../messages/ping';
import {ErrorsThresholdEventEmitter} from '../../events/events';
import {HttpClient, HttpErrorResponse, HttpHeaders} from '@angular/common/http';
import {HttpErrorHandlerService} from '../../http-error-handler/http-error-handler.service';
import {catchError, debounceTime, switchMapTo, tap} from 'rxjs/operators';


export const PING_INTERVAL = 15; // in sec


/**
 * Using only from the NetworkService !!!
 */
@Injectable()
export class PingNotificationRestService {

    private pingSubject: Subject<any> = new Subject<any>();
    private connectionSubject: Subject<boolean> = new BehaviorSubject(true);
    private connectionSubscription: Subscription;
    private errorCounter = 0;
    private start: number;

    private headers: HttpHeaders = new HttpHeaders({
        'Content-Type': 'text/plain'
    });

    constructor(private errorsThresholdEventEmitter: ErrorsThresholdEventEmitter,
                private http: HttpClient,
                private httpErrorHandlerService: HttpErrorHandlerService) {
    }

    private onPost(url: string, message?: PingRequest): Observable<PingResponse> {
        return this.http.post<PingRequest>(url, message, {headers: this.headers, responseType: 'text' as 'json'})
            .pipe(
                catchError((data: HttpErrorResponse) => this.httpErrorHandlerService.process(data))
            );
    }

    notificationListener(): Observable<PingResponse> {
        this.connectionSubject.next(true);
        return this.pingSubject.asObservable();
    }

    startNotification(): void {
        if (this.connectionSubscription) {
            return;
        }
        this.connectionSubscription = this.connectionSubject
            .pipe(
                debounceTime(PING_INTERVAL * 1000),
                tap(() => this.start = new Date().getTime()),
                switchMapTo(this.onPost(environment.LobbyPingApiPath, {} as PingRequest)),
            )
            .subscribe({
                next: (data: PingResponse) => {
                    if (data) {
                        const now = new Date().getTime();
                        const diff = now - this.start;
                        this.pingSubject.next(diff);
                    }

                    // Reset counter
                    this.errorCounter = 0;

                    // Reconnect
                    this.connectionSubject.next(true);
                },
                error: (error: any) => {
                    console.log('Ping error:', error);
                    this.errorCounter++;
                    if (this.errorCounter >= 5) {
                        // Stop ping
                        this.stopNotification();
                    } else {
                        this.restartPing();
                    }
                }
            });
    }

    private restartPing() {
        this.stopNotification();
        this.startNotification();
    }

    stopNotification() {
        if (this.connectionSubscription) {
            this.connectionSubscription.unsubscribe();
            this.connectionSubscription = null;
        }
    }

}
