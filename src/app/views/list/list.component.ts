import {AfterViewInit, Component, ElementRef, OnInit, ViewChild} from '@angular/core';
import {Book, BooksResult, BooksService} from "../../services/books.service";
import {FormControl} from "@angular/forms";
import {debounceTime, delay, distinctUntilChanged, finalize, map, shareReplay, startWith, switchMap} from "rxjs/operators";
import {Storage, Unsubscribe} from "../../misc/decorators.hoc";
import {BehaviorSubject, EMPTY, fromEvent, Observable, of, Subscription} from "rxjs";
import { NgxSpinnerService } from "ngx-bootstrap-spinner";
import {StorageType} from "../../services/storage.service";

const SEARCH: string = 'SEARCH';
const FAVORITES: string = 'FAVORITES';

export interface ISearchObject {
    q?: string,
    startIndex?: number,
    maxResults?: number,
    key?: string
}


const initialSearch: ISearchObject = {q: '', startIndex: 0, maxResults: 30};

@Component({
    selector: 'app-list',
    templateUrl: './list.component.html',
    styleUrls: ['./list.component.scss']
})

@Unsubscribe()
export class ListComponent implements OnInit, AfterViewInit {

    @ViewChild('searchInput') searchInput: ElementRef;

    @Storage<string[]>(FAVORITES, StorageType.Session, [])
    private favorites: string[];

    @Storage<string>(SEARCH, StorageType.Session, '')
    private searchString: string;

    private searchSubject: BehaviorSubject<Partial<ISearchObject>> = new BehaviorSubject<Partial<ISearchObject>>(initialSearch);
    public readonly searchObservable$ = this.searchSubject.asObservable();

    searchObject: ISearchObject;

    showFavorites: boolean = false;

    books: Partial<Book>[] = [];
    filtered: Partial<Book>[] = [];
    totalBooks: number = 0;
    error: any;

    throttle = 300;
    scrollDistance = 1;

    private valueChangeSubscription: Subscription = new Subscription();
    private loadSubscription: Subscription;

    constructor( private booksService: BooksService, private spinner: NgxSpinnerService ) {}

    ngOnInit() {

        this.searchObservable$
            .pipe(
                switchMap(( s: ISearchObject ) => {
                    if (!s.q || s.q === '') {
                        this.resetData();
                        return EMPTY;
                    } else {
                        return of(s);
                    }
                })
            )
            .subscribe(( s: ISearchObject ) => {
                this.error = null;
                this.spinner.show();
                this.loadSubscription = this.booksService.loadBooks(s)
                    .pipe(
                        shareReplay()
                    )
                    .subscribe(
                        {
                            next: ( result: BooksResult ) => {
                                this.totalBooks = result.totalItems;
                                this.books = [...this.books, ...result.items].map(book => this.favorites.indexOf(book.id) !== -1 ? ({...book, favorite: true}) : ({...book}));
                                this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
                            },
                            error: err => {
                                this.resetData();
                                this.error = err.error && err.error.error && err.error.error.message ? err.error.error.message : (err.message ? err.message : 'Unknown error');
                            },

                        }
                    )
                    .add( () => {
                        this.spinner.hide();
                    })
            })

        this.searchObject = {...initialSearch, q: this.searchString};
        this.searchSubject.next(this.searchObject);
    }

    ngAfterViewInit(): void {
        this.valueChangeSubscription.add(
            fromEvent(this.searchInput.nativeElement, 'keyup')
                .pipe(
                    map((res: any) => res?.target.value),
                    debounceTime(500),
                    distinctUntilChanged(),
                )
                .subscribe((value: string) => {
                    this.resetData();
                    this.searchString = value;
                    this.searchObject = {...initialSearch, q: value};
                    this.searchSubject.next(this.searchObject);
                })
        )
        this.searchInput.nativeElement.value = this.searchString;
    }

    private resetData(): void {
        this.totalBooks = 0;
        this.books = [];
        this.filtered = [];
    }

    onScroll(event: any) {
        console.log('scrolled!!', event);
        const offset = this.searchObject.startIndex + this.searchObject.maxResults > this.totalBooks ? this.totalBooks - this.searchObject.startIndex : this.searchObject.maxResults;
        const start = this.searchObject.startIndex + offset;
        this.searchObject = {
            ...this.searchObject,
            startIndex: start
        }
        this.searchSubject.next(this.searchObject);
    }

    onUp(event: any) {
        console.log('scrolled up!', event);
    }

    toggleFavorites(book: Partial<Book>): void {
        book.favorite = !book.favorite;
        if (book.favorite) {
            this.favorites = [...this.favorites, book.id];
        } else {
            this.favorites = this.favorites.filter(item => item !== book.id)
        }
        this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
    }

    onCheck(event): void {
        this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
    }
}
