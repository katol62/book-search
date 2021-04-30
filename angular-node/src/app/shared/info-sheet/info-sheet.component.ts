import {Component, Inject, OnInit} from '@angular/core';
import {MAT_BOTTOM_SHEET_DATA, MatBottomSheetRef} from '@angular/material/bottom-sheet';
import {ISheetData} from '../services/info.service';

@Component({
  selector: 'app-info-sheet',
  templateUrl: './info-sheet.component.html',
  styleUrls: ['./info-sheet.component.scss']
})
export class InfoSheetComponent implements OnInit {

  private defaultData: ISheetData = {
    title: 'Any',
  };

  constructor(
    @Inject(MAT_BOTTOM_SHEET_DATA)
    public data: ISheetData,
    private bottomSheetRef: MatBottomSheetRef<InfoSheetComponent>
  ) {
    this.data = {
      ...this.defaultData,
      ...data
    };
  }

  ngOnInit(): void {
  }

}
