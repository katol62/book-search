import {Injectable} from '@angular/core';
import {HttpClient, HttpParams} from "@angular/common/http";
import {ISearchObject} from "../views/list/list.component";
import {Observable} from "rxjs";

export interface Book {
    id: string;
    volumeInfo?: {
        title: string;
        subtitle: string;
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

    constructor( private http: HttpClient ) {}

    public loadBooks(so: Partial<ISearchObject>): Observable<any> {
        let params: HttpParams = new HttpParams({fromObject: {...so, key: this.key} as any});
        return this.http.get(this.API_PATH, {params: params})
    }

    // private parseParams(o: Object): HttpParams {
    //     return Object.entries(o).reduce((params, [key, value]) => params.set(key, value), new HttpParams());
    // }

}
