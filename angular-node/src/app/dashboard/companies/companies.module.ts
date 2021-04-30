import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CompaniesRoutingModule } from './companies-routing.module';
import { CompaniesComponent } from './companies.component';
import {MatPaginatorModule} from '@angular/material/paginator';
import {MatHeaderRowDef, MatRow, MatRowDef, MatTableModule} from '@angular/material/table';
import {MatButtonModule} from '@angular/material/button';
import {MatIconModule} from '@angular/material/icon';
import {CdkTableModule} from '@angular/cdk/table';
import {SharedModule} from '../../shared/shared.module';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {DashboardModule} from '../dashboard.module';
import { CompanyEditComponent } from './company-edit/company-edit.component';
import { CompanyListComponent } from './company-list/company-list.component';
import { TerminalEditComponent } from './terminals/terminal-edit/terminal-edit.component';


@NgModule({
  declarations: [
    CompaniesComponent,
    CompanyEditComponent,
    CompanyListComponent,
    TerminalEditComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    CompaniesRoutingModule
  ]
})
export class CompaniesModule { }
