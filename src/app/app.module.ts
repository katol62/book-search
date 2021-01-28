import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './views/list/list.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BooksService} from "./services/books.service";
import {HttpClientModule, HttpClient} from "@angular/common/http";
import {InfiniteScrollModule} from "ngx-infinite-scroll";


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
        FormsModule
    ],
  providers: [BooksService],
  bootstrap: [AppComponent]
})
export class AppModule { }
