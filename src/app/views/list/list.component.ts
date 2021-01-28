import {Component, OnInit} from '@angular/core';
import {Book, BooksResult, BooksService} from "../../services/books.service";
import {FormControl} from "@angular/forms";
import {debounceTime, distinctUntilChanged} from "rxjs/operators";

const SEARCH: string = 'SEARCH';
const FAVORITES: string = 'FAVORITES';

@Component({
    selector: 'app-list',
    templateUrl: './list.component.html',
    styleUrls: ['./list.component.scss']
})
export class ListComponent implements OnInit {

    favorites: string[] = [];
    showFavorites: boolean = false;

    books: Book[] = [];
    filtered: Book[] = [];
    totalBooks: number = 0;
    search: FormControl = new FormControl();
    loading: boolean;

    searchStart: number = 0;
    searchOffset: number = 30;

    throttle = 300;
    scrollDistance = 1;

    constructor( private booksService: BooksService ) {
    }

    ngOnInit() {
        const fav = JSON.parse(sessionStorage.getItem(FAVORITES));
        this.favorites = fav ? fav : [];
        this.search.setValue(this.getStored())
        this.search.valueChanges
            .pipe(
                debounceTime(1000),
                distinctUntilChanged()
            )
            .subscribe( value => {
                this.books = [];
                this.searchStart = 0;
                sessionStorage.setItem(SEARCH, value)
                this.loadBooks()
            })

        this.loadBooks();
    }

    loadBooks() {
        const q = this.search.value ? this.search.value : null;
        this.booksService.getBooks(q, this.searchStart, this.searchOffset)
            .subscribe({
                next: (result: BooksResult) => {
                    this.totalBooks = result.totalItems;
                    this.books = [...this.books, ...result.items].map(book => this.favorites.indexOf(book.id) !== -1 ? ({...book, favorite: true}) : ({...book}));
                    this.filtered = this.showFavorites ? this.books.filter(book => book.favorite) : [...this.books];
                },
                error: err => {
                }
            })
    }

    onScroll(event) {
        console.log('scrolled!!');
        const offset = this.searchStart + this.searchOffset > this.totalBooks ? this.totalBooks - this.searchStart : this.searchOffset;
        this.searchStart += offset;
        this.loadBooks();
    }

    onUp(event) {
        console.log('scrolled up!', event);
    }

    private getStored(): string {
        const stored = sessionStorage.getItem(SEARCH);
        return stored ? stored : null;
    }

    private getFavorites

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
