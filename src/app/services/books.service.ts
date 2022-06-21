import {Injectable} from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpParams} from "@angular/common/http";
import {ISearchObject} from "../views/list/list.component";
import {Observable, throwError} from "rxjs";
import {catchError, map, shareReplay} from "rxjs/operators";
import {AlertService, EAlertType} from "./alert/alert.service";

export interface Book {
    id: string;
    volumeInfo?: {
        title: string;
        subtitle: string;
        authors: [string];
        description: string;
    },
    favorite?: boolean;
}

export interface BooksResult {
    items: Book[],
    kind: string;
    totalItems: number;
}

@Injectable()
export class BooksService {

    private key: string = 'AIzaSyDorwKcoAq4X6LrWU5ojreQVKA6EOdqETw';
    private API_PATH: string = `https://www.googleapis.com/books/v1/volumes`;

    constructor( private http: HttpClient, private alertService: AlertService ) {}

    public loadBooks(so: Partial<ISearchObject>): Observable<any> {
        let params: HttpParams = new HttpParams({fromObject: {...so, key: this.key} as any});
        return this.http.get(this.API_PATH, {params}).pipe(
            shareReplay(),
            map((result: any) => {
                this.alertService.show({type: EAlertType.SUCCESS, heading: 'Success', message: 'Data loaded'});
                return result;
            }),
            catchError((error: HttpErrorResponse) => {
                this.alertService.show({type: EAlertType.DANGER, heading: 'Error', message: error.statusText})
                return throwError(error);
            })

        )
    }

    // private parseParams(o: Object): HttpParams {
    //     return Object.entries(o).reduce((params, [key, value]) => params.set(key, value), new HttpParams());
    // }

}
