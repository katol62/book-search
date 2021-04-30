import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {DashboardComponent} from './dashboard.component';
import {AuthGuard} from '../shared/guards/auth.guard';
import {adminsPath, cardsPath, companiesPath, homePath} from '../routes';

const routes: Routes = [
  {path: '', component: DashboardComponent, canActivate: [AuthGuard],
    children: [
      {path: '', redirectTo: homePath},
      {path: homePath, loadChildren: () => import('./home/home.module').then(m => m.HomeModule)},
      {path: companiesPath, loadChildren: () => import('./companies/companies.module').then(m => m.CompaniesModule)},
      {path: cardsPath, loadChildren: () => import('./cards/cards.module').then(m => m.CardsModule)},
      {path: adminsPath, loadChildren: () => import('./admins/admins.module').then(m => m.AdminsModule)},
    ]
  }
];
@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DashboardRoutingModule { }
