import { Injectable } from '@angular/core';
import {MatDialog, MatDialogRef} from '@angular/material/dialog';
import {DialogComponent} from '../dialog/dialog.component';
import {Observable} from 'rxjs';
import {map, take} from 'rxjs/operators';

export interface IDialogOptions {
  title?: string;
  message?: string;
  cancelText?: string;
  confirmText?: string;
}

@Injectable({
  providedIn: 'root'
})
export class DialogService {

  dialogRef: MatDialogRef<DialogComponent>;

  constructor(private dialog: MatDialog) { }

  public open(options?: IDialogOptions) {
    this.dialogRef = this.dialog.open(DialogComponent, {
      data: options
    });
  }
  public confirmed(): Observable<any> {

    return this.dialogRef.afterClosed().pipe(take(1), map(res => {
        return res;
      }
    ));
  }
}
