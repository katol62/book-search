import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";

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

    constructor( private http: HttpClient ) {
    }

    public getBooks( q: string, start: number, offset: number ) {
        return this.http.get(`https://www.googleapis.com/books/v1/volumes?keyes&key=${this.key}&q=${q}&startIndex=${start}&maxResults=${offset}`);
    }

}
