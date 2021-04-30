import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {CardsComponent} from './cards.component';
import {AuthGuard} from '../../shared/guards/auth.guard';
import {AdminsComponent} from '../admins/admins.component';
import {RoleGuard} from '../../shared/guards/role.guard';
import {CardsListComponent} from './cards-list/cards-list.component';
import {CardsEditComponent} from './cards-edit/cards-edit.component';
import {createPath} from '../../routes';


const routes: Routes = [
  {path: '', component: CardsComponent, canActivate: [AuthGuard, RoleGuard], data: {roles: ['super', 'admin']},
    children: [
      {path: '', component: CardsListComponent},
      {path: ':id', component: CardsEditComponent},
      {path: createPath, component: CardsEditComponent},
      {path: '**', redirectTo: ''}
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CardsRoutingModule { }
