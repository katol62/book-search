import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CardsRoutingModule } from './cards-routing.module';
import { CardsComponent } from './cards.component';
import { CardsListComponent } from './cards-list/cards-list.component';
import {SharedModule} from '../../shared/shared.module';
import { CardsEditComponent } from './cards-edit/cards-edit.component';


@NgModule({
  declarations: [CardsComponent, CardsListComponent, CardsEditComponent],
  imports: [
    CommonModule,
    SharedModule,
    CardsRoutingModule
  ]
})
export class CardsModule { }
