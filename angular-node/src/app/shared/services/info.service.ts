import { Injectable } from '@angular/core';
import {InfoSheetComponent} from '../info-sheet/info-sheet.component';
import {MatBottomSheet, MatBottomSheetRef} from '@angular/material/bottom-sheet';
import {DialogComponent} from '../dialog/dialog.component';
import {Observable} from 'rxjs';
import {map, take} from 'rxjs/operators';
import {IDialogOptions} from './dialog.service';

export interface ISheetData {
  title: string;
  infoContent?: string;
  infoItems?: any[];
}

@Injectable({
  providedIn: 'root'
})
export class InfoService {

  bottomSheetRef: MatBottomSheetRef<InfoSheetComponent>;
  constructor(private bottomSheet: MatBottomSheet) { }

  public open(options?: ISheetData) {
    this.bottomSheetRef = this.bottomSheet.open(InfoSheetComponent, {
      data: options
    });
  }
  public confirmed(): Observable<any> {
    return this.bottomSheetRef.afterDismissed().pipe(take(1), map(res => {
        return res;
      }
    ));
  }

}
