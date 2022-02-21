import { BrowserModule } from '@angular/platform-browser';
import {Injector, NgModule} from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './views/list/list.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BooksService} from "./services/books.service";
import {HttpClientModule, HttpClient} from "@angular/common/http";
import {InfiniteScrollModule} from "ngx-infinite-scroll";
import {StorageService} from "./services/storage.service";


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
  providers: [BooksService, StorageService],
  bootstrap: [AppComponent]
})
export class AppModule {}
