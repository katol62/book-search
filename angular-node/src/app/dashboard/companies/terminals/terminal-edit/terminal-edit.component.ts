import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {BasicComponent} from '../../../basic/basic.component';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {RestService} from '../../../../shared/services/rest.service';
import {ActivatedRoute} from '@angular/router';
import {IMessageItem, NotificationMessageType, NotificationService} from '../../../../shared/services/notification.service';
import {ITerminal} from '../../../../../../server/models/Terminal';
import {companiesPath} from '../../../../routes';
import {
  ICompanyResponse,
  ITerminalResponse,
  ITerminalUpdateRequest,
  ITerminalUpdateResponse
} from '../../../../../../server/interfaces/http-data';
import {ICompanyExtended} from '../../../../../../server/models/Company';
import {forkJoin} from 'rxjs';
import {IUser} from '../../../../../../server/models/User';

@Component({
  selector: 'app-terminal-edit',
  templateUrl: './terminal-edit.component.html',
  styleUrls: ['./terminal-edit.component.scss']
})
export class TerminalEditComponent extends BasicComponent implements OnInit, OnDestroy {

  public form: FormGroup;
  public cid: number;
  public tid: number;
  public company: ICompanyExtended;

  constructor(
    protected injector: Injector,
    private restService: RestService,
    private activatedRoute: ActivatedRoute,
    private formBuilder: FormBuilder,
    private notificationService: NotificationService
  ) {
    super(injector);
  }

  ngOnInit(): void {
    super.ngOnInit();
  }

  ngOnDestroy(): void {
    super.ngOnDestroy();
  }

  protected afterInit(): void {
    this.form = this.formBuilder.group({
      id: [null],
      name: ['', Validators.compose([Validators.required])],
      company: [''],
      commission: [''],
      place: [''],
    });

    const id = this.activatedRoute.snapshot.paramMap.get('id');
    const tid = this.activatedRoute.snapshot.paramMap.get('tid');

    if (!id) {
      this.router.navigate([companiesPath]);
      return;
    } else {
      this.cid = Number(id);
      this.form.patchValue({company: id});
    }
    if (tid) {
      this.tid = Number(tid);
      this.getCompanyTerminal();
    } else {
      this.form.patchValue({commission: '2'});
      this.getCompany();
    }

  }

  /**
   * REST
   */

  getCompany(): void {
    this.restService.get('companies/' + String(this.cid))
      .subscribe( {
        next: (result: ICompanyResponse) => {
          this.company = result.data.company;
        }
      });
  }

  getCompanyTerminal(): void {
    const company = this.restService.get('companies/' + String(this.cid));
    const terminal = this.restService.get('terminals/' + String(this.tid));
    forkJoin([company, terminal])
      .subscribe(
        (result: any) => {
          this.company = result[0].data;
          this.form.patchValue(result[1].data);
        });

  }

  /**
   * Actions
   */

  save(terminal: ITerminal): void {
    const request: ITerminalUpdateRequest = {terminal};
    if (this.tid) {
      this.restService.put('terminals/' + this.tid, request)
        .subscribe({
          next: (result: ITerminalUpdateResponse) => {
            const mess: IMessageItem = {
              message: result.message,
              messageType: NotificationMessageType.success};
            this.notificationService.show(mess);
          }
        });
    } else {
      this.restService.post('terminals/create', request)
        .subscribe({
          next: (result: ITerminalUpdateResponse) => {
            const mess: IMessageItem = {
              message: result.message,
              messageType: NotificationMessageType.success};
            this.notificationService.show(mess);
          }
        });

    }
  }

  onSubmit(): void {
    if (this.form.invalid) {
      return;
    }
    if (!this.form.touched) {
      this.notificationService.show({message: 'Nothing changed',
        messageType: NotificationMessageType.warning});
      return;
    }
    this.save(this.form.value);
  }

  back(): void {
    this.router.navigate([companiesPath]);
  }

}
