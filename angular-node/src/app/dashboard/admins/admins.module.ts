import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AdminsRoutingModule } from './admins-routing.module';
import { AdminsComponent } from './admins.component';
import { AdminsListComponent } from './admins-list/admins-list.component';
import { AdminsEditComponent } from './admins-edit/admins-edit.component';
import {SharedModule} from '../../shared/shared.module';
import {MatCheckboxModule} from '@angular/material/checkbox';


@NgModule({
  declarations: [AdminsComponent, AdminsListComponent, AdminsEditComponent],
    imports: [
        CommonModule,
        SharedModule,
        AdminsRoutingModule
    ]
})
export class AdminsModule { }
