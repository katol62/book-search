import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './components/list/list.component';
import { WithdrawComponent } from './components/withdraw/withdraw.component';
import {HttpClientModule} from '@angular/common/http';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {WithdrawService} from './services/withdraw.service';
import {StorageService} from "./services/storage.service";
import { ResultComponent } from './components/result/result.component';


@NgModule({
  declarations: [
    AppComponent,
    ListComponent,
    WithdrawComponent,
    ResultComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    AppRoutingModule
  ],
  providers: [WithdrawService, StorageService],
  bootstrap: [AppComponent]
})
export class AppModule { }
