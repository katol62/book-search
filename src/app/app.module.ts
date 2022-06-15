import { BrowserModule } from '@angular/platform-browser';
import {CUSTOM_ELEMENTS_SCHEMA, NgModule} from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './views/list/list.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BooksService} from "./services/books.service";
import {HttpClientModule, HttpClient} from "@angular/common/http";
import {InfiniteScrollModule} from "ngx-infinite-scroll";
import {StorageService} from "./services/storage.service";
import {NgxSpinnerModule} from "ngx-bootstrap-spinner";


@NgModule({
  declarations: [
    AppComponent,
    ListComponent
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        ReactiveFormsModule,
        InfiniteScrollModule,
        HttpClientModule,
        FormsModule,
        NgxSpinnerModule
    ],
    providers: [BooksService, StorageService],
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    bootstrap: [AppComponent]
})
export class AppModule {}
