import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';
import { DashboardComponent } from './dashboard.component';
import {SharedModule} from '../shared/shared.module';
import { NavbarComponent } from './navbar/navbar.component';
import { FooterComponent } from './footer/footer.component';
import {MatToolbarModule} from '@angular/material/toolbar';
import {MatIconModule} from '@angular/material/icon';


@NgModule({
  declarations: [DashboardComponent, NavbarComponent, FooterComponent],
  imports: [
    CommonModule,
    SharedModule,
    DashboardRoutingModule,
    MatToolbarModule,
    MatIconModule
  ],
  exports: [
  ],
  providers: [
  ]
})
export class DashboardModule { }
