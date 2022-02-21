import {Component, OnInit} from '@angular/core';
import {Book, BooksResult, BooksService} from "../../services/books.service";
import {FormControl} from "@angular/forms";
import {debounceTime, distinctUntilChanged} from "rxjs/operators";
import {Storage, StorageType, Unsubscribe} from "../../misc/decorators.hoc";
import {Subscription} from "rxjs";

const SEARCH: string = 'SEARCH';
const FAVORITES: string = 'FAVORITES';

export interface ISearchObject {
    q?: any,
    startIndex?: any,
    maxResults?: any
}

@Component({
    selector: 'app-list',
    templateUrl: './list.component.html',
    styleUrls: ['./list.component.scss']
})

@Unsubscribe()
export class ListComponent implements OnInit {

    @Storage<string[]>(FAVORITES, StorageType.Session, [])
    private favorites: string[];

    @Storage<string>(SEARCH, StorageType.Session, '')
    private searchString: string;

    searchObject: ISearchObject;

    showFavorites: boolean = false;

    books: Book[] = [];
    filtered: Book[] = [];
    totalBooks: number = 0;
    search: FormControl = new FormControl();
    loading: boolean;
    error: any;

    throttle = 300;
    scrollDistance = 1;

    private valueChangeSubscription: Subscription;
    private loadSubscription: Subscription;

    constructor( private booksService: BooksService ) {
    }

    ngOnInit() {
        const s = this.searchString ? this.searchString : '';
        this.searchObject = {q: this.searchString, startIndex: 0, maxResults: 30}
        this.search.setValue(s);
        this.valueChangeSubscription = this.search.valueChanges
            .pipe(
                debounceTime(1000),
                distinctUntilChanged()
            )
            .subscribe( value => {
                this.books = [];
                // this.searchStart = 0;
                this.searchString = value;
                this.searchObject = {
                    ...this.searchObject,
                    q: this.searchString
                }
                this.loadBooks()
            })

        this.loadBooks();
    }

    loadBooks() {
        this.error = null;
        const s = this.searchObject;
        this.loadSubscription = this.booksService.getBooks(s.q, s.startIndex, s.maxResults)
            .subscribe({
                next: (result: BooksResult) => {
                    this.totalBooks = result.totalItems;
                    this.books = [...this.books, ...result.items].map(book => this.favorites.indexOf(book.id) !== -1 ? ({...book, favorite: true}) : ({...book}));
                    this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
                },
                error: err => {
                    this.totalBooks = 0;
                    this.books = [];
                    this.filtered = [];
                    this.error = err.error && err.error.error && err.error.error.message ? err.error.error.message : (err.message ? err.message : 'Unknown error');
                }
            })
    }

    onScroll(event) {
        console.log('scrolled!!');
        const offset = this.searchObject.startIndex + this.searchObject.maxResults > this.totalBooks ? this.totalBooks - this.searchObject.startIndex : this.searchObject.maxResults;
        const start = this.searchObject.startIndex + offset;
        this.searchObject = {
            ...this.searchObject,
            startIndex: start
        }
        // this.searchStart += offset;
        this.loadBooks();
    }

    onUp(event) {
        console.log('scrolled up!', event);
    }

    private getStored(): string {
        const stored = sessionStorage.getItem(SEARCH);
        return stored ? stored : null;
    }

    toggleFavorites(book: Book) {
        book.favorite = !book.favorite;
        if (book.favorite) {
            this.favorites = [...this.favorites, book.id];
        } else {
            this.favorites = this.favorites.filter(item => item !== book.id)
        }
        sessionStorage.setItem(FAVORITES, JSON.stringify(this.favorites));
        console.log(this.favorites);
        this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
    }

    onCheck(event) {
        const checked = event.currentTarget.checked;
        console.log(this.showFavorites);
        this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
    }
}
