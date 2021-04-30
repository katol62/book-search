import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {AdminsComponent} from './admins.component';
import {AuthGuard} from '../../shared/guards/auth.guard';
import {AdminsListComponent} from './admins-list/admins-list.component';
import {createPath} from '../../routes';
import {AdminsEditComponent} from './admins-edit/admins-edit.component';
import {RoleGuard} from '../../shared/guards/role.guard';


const routes: Routes = [
  {path: '', component: AdminsComponent, canActivate: [AuthGuard, RoleGuard], data: {roles: ['super', 'admin']},
    children: [
      {path: '', component: AdminsListComponent},
      {path: createPath, component: AdminsEditComponent},
      {path: ':id', component: AdminsEditComponent},
      {path: '**', redirectTo: ''}
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminsRoutingModule { }
