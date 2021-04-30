import {ModuleWithProviders, NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {HttpClientModule} from '@angular/common/http';
import {AuthService} from './services/auth.service';
import {RestService} from './services/rest.service';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { PipesPipe } from './pipes/pipes.pipe';
import {MatToolbarModule} from '@angular/material/toolbar';
import {MatCardModule} from '@angular/material/card';
import {MatInputModule} from '@angular/material/input';
import {FlexLayoutModule} from '@angular/flex-layout';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatButtonModule} from '@angular/material/button';
import {RouterModule} from '@angular/router';
import {CdkTableModule} from '@angular/cdk/table';
import { MessageComponent } from './message/message.component';
import {NotificationService} from './services/notification.service';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatIconModule} from '@angular/material/icon';
import {MatPaginatorModule} from '@angular/material/paginator';
import {MatTableModule} from '@angular/material/table';
import {MatCheckboxModule} from '@angular/material/checkbox';
import {ValidationService} from './services/validation.service';
import { DialogComponent } from './dialog/dialog.component';
import {DialogService} from './services/dialog.service';
import {MatDialogModule} from '@angular/material/dialog';
import {MatAutocompleteModule} from '@angular/material/autocomplete';
import {MatSelectModule} from '@angular/material/select';
import {MatDatepicker, MatDatepickerModule} from '@angular/material/datepicker';
import {MatNativeDateModule} from '@angular/material/core';
import {MatSortModule} from '@angular/material/sort';
import {MatBottomSheetModule} from '@angular/material/bottom-sheet';
import { InfoSheetComponent } from './info-sheet/info-sheet.component';
import {MatListModule} from '@angular/material/list';
import {InfoService} from './services/info.service';


@NgModule({
  declarations: [PipesPipe, MessageComponent, DialogComponent, InfoSheetComponent],
  imports: [
    CommonModule,
    FormsModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatToolbarModule,
    MatCardModule,
    MatInputModule,
    MatIconModule,
    MatPaginatorModule,
    MatTableModule,
    MatButtonModule,
    MatCheckboxModule,
    MatDialogModule,
    MatAutocompleteModule,
    MatSelectModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatSortModule,
    MatBottomSheetModule,
    MatListModule,
    FlexLayoutModule,
    MatFormFieldModule,
    MatButtonModule,
    MatSnackBarModule,
    CdkTableModule,
  ],
  exports: [
    CommonModule,
    FormsModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatToolbarModule,
    MatCardModule,
    MatInputModule,
    MatIconModule,
    MatPaginatorModule,
    MatTableModule,
    MatButtonModule,
    MatCheckboxModule,
    MatDialogModule,
    MatAutocompleteModule,
    MatSelectModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatSortModule,
    MatBottomSheetModule,
    MatListModule,
    FlexLayoutModule,
    MatFormFieldModule,
    MatButtonModule,
    MatSnackBarModule,
    CdkTableModule,
    MessageComponent
  ],
  entryComponents: [],
  providers: []
})
export class SharedModule {
  static forRoot(): ModuleWithProviders {
    return {
      ngModule: SharedModule,
      providers: [
        // Auth
        AuthService,
        // REST
        RestService,
        NotificationService,
        ValidationService,
        DialogService,
        InfoService
      ]
    };
  }
  static forChild(): ModuleWithProviders {
    return {
      ngModule: SharedModule,
      providers: [
        // Auth
        AuthService,
        // REST
        RestService,
        NotificationService,
        ValidationService,
        DialogService,
        InfoService
      ]
    };
  }

}
