import { Component, OnInit } from '@angular/core';
import {AlertService, IConfig} from "./alert.service";
import {switchMap} from "rxjs/operators";
import {EMPTY, of} from "rxjs";

@Component({
  selector: 'app-alert',
  templateUrl: './alert.component.html',
  styleUrls: ['./alert.component.scss']
})
export class AlertComponent implements OnInit {

    public config: IConfig;

    constructor(private alertService: AlertService) { }

    ngOnInit(): void {
        this.alertService.alert$
            .pipe(
                switchMap( (config: IConfig) => {
                    console.log(config);
                    return of(config)
                })
            )
            .subscribe((config: IConfig) => {
                this.config = config;
            })
    }

    onClose(event) {
        console.log(event)
        this.alertService.hide({...this.config});
    }

}
