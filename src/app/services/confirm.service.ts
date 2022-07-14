import {Inject, Injectable, Renderer2, RendererFactory2} from '@angular/core';
import {BsModalService} from "ngx-bootstrap/modal";
import {ConfirmComponent} from "./confirm/confirm.component";

export interface IConfirm {
    message: string,
    title: string,
    alertMode: boolean,
    error: boolean
}

@Injectable({
  providedIn: 'root'
})
export class ConfirmService {

    constructor(public bsModalService: BsModalService) {}

    confirm(confirmObj: Partial<IConfirm>): Promise<boolean> {
        const modal = this.bsModalService.show(ConfirmComponent, { initialState: { ...confirmObj, alertMode: false }});
        return new Promise<boolean>((resolve, reject) => modal.content.result.subscribe((result) => resolve(result) ));
    }
    alert(confirmObj: Partial<IConfirm>): Promise<boolean> {
        const modal = this.bsModalService.show(ConfirmComponent, { initialState: { ...confirmObj, alertMode: true }});
        return new Promise<boolean>((resolve, reject) => modal.content.result.subscribe((result) => resolve(result) ));
    }

}
