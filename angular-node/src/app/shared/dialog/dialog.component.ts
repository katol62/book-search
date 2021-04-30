import {ChangeDetectionStrategy, Component, HostListener, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {IDialogOptions} from '../services/dialog.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-dialog',
  templateUrl: './dialog.component.html',
  styleUrls: ['./dialog.component.scss']
})
export class DialogComponent implements OnInit {

  private defaultOptions: IDialogOptions = {
    title: '',
    message: '',
    cancelText: 'Cancel',
    confirmText: ''
  };

  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: IDialogOptions,
    private mdDialogRef: MatDialogRef<DialogComponent>
    ) {
    this.data = {
      ...this.defaultOptions,
      ...data
    };
  }

  ngOnInit(): void {
  }

  public cancel() {
    this.close(false);
  }
  public close(value) {
    this.mdDialogRef.close(value);
  }
  public confirm() {
    this.close(true);
  }
  @HostListener('keydown.esc')
  public onEsc() {
    this.close(false);
  }

}
