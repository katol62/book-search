import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { ListComponent } from './components/list/list.component';
import { WithdrawComponent } from './components/withdraw/withdraw.component';
import {HttpClientModule} from '@angular/common/http';
import {FormsModule} from '@angular/forms';
import {WithdrawService} from './services/withdraw.service';


@NgModule({
  declarations: [
    AppComponent,
    ListComponent,
    WithdrawComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    AppRoutingModule
  ],
  providers: [WithdrawService],
  bootstrap: [AppComponent]
})
export class AppModule { }
