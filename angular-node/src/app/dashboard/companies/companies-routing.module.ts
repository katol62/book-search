import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {CompaniesComponent} from './companies.component';
import {companiesPath, createPath} from '../../routes';
import {AuthGuard} from '../../shared/guards/auth.guard';
import {CompanyEditComponent} from './company-edit/company-edit.component';
import {CompanyListComponent} from './company-list/company-list.component';
import {TerminalEditComponent} from './terminals/terminal-edit/terminal-edit.component';


const routes: Routes = [
  {path: '', component: CompaniesComponent, canActivate: [AuthGuard],
    children: [
      {path: '', component: CompanyListComponent},
      {path: createPath, component: CompanyEditComponent},
      {path: ':id', component: CompanyEditComponent},
      {path: ':id/terminals/create', component: TerminalEditComponent},
      {path: ':id/terminals/:tid', component: TerminalEditComponent},
      {path: '**', redirectTo: ''}
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CompaniesRoutingModule { }
