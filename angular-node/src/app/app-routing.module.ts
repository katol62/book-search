import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {dashboardPath, loginPath} from './routes';


const routes: Routes = [
  { path: loginPath, loadChildren: () => import('./login/login.module').then(m => m.LoginModule) },
  { path: dashboardPath, loadChildren: () => import('./dashboard/dashboard.module').then(m => m.DashboardModule) },
  { path: '**', redirectTo: '' }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
