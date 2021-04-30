import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {AuthGuardService} from '../shared/auth/auth-guard.service';
import {HomeComponent} from './home.component';
import {PromotionGuard} from '../shared/guards/promotion.guard';


const routes: Routes = [{
  path: '',
  component: HomeComponent,
  canActivate: [AuthGuardService, PromotionGuard],
  canDeactivate: [AuthGuardService]
}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HomeRoutingModule { }
