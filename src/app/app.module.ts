import { BrowserModule } from '@angular/platform-browser';
import {CUSTOM_ELEMENTS_SCHEMA, Injector, NgModule} from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './views/list/list.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BooksService} from "./services/books.service";
import {HttpClientModule, HttpClient} from "@angular/common/http";
import {InfiniteScrollModule} from "ngx-infinite-scroll";
import {StorageService} from "./services/storage.service";
import {NgxSpinnerModule} from "ngx-bootstrap-spinner";
import { AlertComponent } from './services/alert/alert.component';
import {AlertConfig, AlertModule} from "ngx-bootstrap/alert";
import {AlertService} from "./services/alert/alert.service";
import { ConfirmComponent } from './services/confirm/confirm.component';
import {BsModalRef, BsModalService, ModalModule} from "ngx-bootstrap/modal";
import {ConfirmService} from "./services/confirm.service";


@NgModule({
  declarations: [
    AppComponent,
    ListComponent,
    AlertComponent,
    ConfirmComponent
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        ReactiveFormsModule,
        InfiniteScrollModule,
        HttpClientModule,
        FormsModule,
        NgxSpinnerModule,
        AlertModule,
        ModalModule.forRoot()
    ],
    providers: [BooksService, StorageService, AlertService, AlertConfig, BsModalService, ConfirmService, BsModalRef],
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    bootstrap: [AppComponent]
})
export class AppModule {
    static injector : Injector = null;
    constructor(public injector: Injector) {
        AppModule.injector = injector;
    }
}
