import {Component, Input, OnInit} from '@angular/core';
import {Subject} from "rxjs";
import {BsModalRef} from "ngx-bootstrap/modal";
import {IConfirm} from "../confirm.service";

@Component({
  selector: 'app-confirm',
  templateUrl: './confirm.component.html',
  styleUrls: ['./confirm.component.scss']
})
export class ConfirmComponent implements OnInit {

    @Input() message: string;

    result: Subject<boolean> = new Subject<boolean>();

    @Input()
    public alertMode: boolean = false;
    @Input()
    public error: boolean = false;
    @Input()
    public title: string;

    constructor(public modalRef: BsModalRef) { }

    confirm(): void {
        this.result.next(true);
        this.modalRef.hide();
    }

    decline(): void {
        this.result.next(false);
        this.modalRef.hide();
    }

    ngOnInit() {
    }

}
