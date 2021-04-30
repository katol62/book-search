import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {BasicComponent} from '../../basic/basic.component';
import {FormBuilder, FormGroup} from '@angular/forms';
import {RestService} from '../../../shared/services/rest.service';
import {ActivatedRoute} from '@angular/router';
import {NotificationMessageType, NotificationService} from '../../../shared/services/notification.service';
import {IUser} from '../../../../../server/models/User';
import {ICompany} from '../../../../../server/models/Company';
import {IAdminsResponse, IBaseResponse, ICompaniesResponse} from '../../../../../server/interfaces/http-data';
import {MatTableDataSource} from '@angular/material/table';
import {forkJoin} from 'rxjs';
import {ICard} from '../../../../../server/models/Card';
import {cardsPath, companiesPath} from '../../../routes';

@Component({
  selector: 'app-cards-edit',
  templateUrl: './cards-edit.component.html',
  styleUrls: ['./cards-edit.component.scss']
})
export class CardsEditComponent extends BasicComponent implements OnInit, OnDestroy {

  public admins: IUser[];
  public companies: ICompany[];
  public card: ICard;

  public form: FormGroup;
  public id: number;

  public statuses: any[] = [
    {label: 'published', value: 'published'},
    {label: 'sold', value: 'sold'},
    {label: 'activated', value: 'activated'},
    {label: 'overdue', value: 'overdue'},
    {label: 'blocked', value: 'blocked'},
  ];

  public types: any[] = [
    {label: 'adult', value: 'adult'},
    {label: 'child', value: 'child'},
    {label: 'group', value: 'group'},
    {label: 'other', value: 'other'}
  ];

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

  protected afterInit(): void {
    this.form = this.formBuilder.group({
      id: [null],
      type: [''],
      status: [''],
      lifetime: [''],
      company_id: [''],
      servicetime: [''],
      owner: [''],
      prim: [''],
      test: [''],
      isTest: [false]
    });

    const id = this.activatedRoute.snapshot.paramMap.get('id');
    const observables: any = [];
    if (id) {
      this.id = Number(id);
      const card = this.restService.get('cards/' + String(id));
      observables.push(card);
      if (this.authInfo.user.role === 'super') {
        const admins = this.restService.get('admins');
        observables.push(admins);
      }
    }
    if (this.authInfo.user.role === 'super') {
      const admins = this.restService.get('admins');
      observables.push(admins);
    }
    if (this.authInfo.user.role === 'admin') {
      const companies = this.restService.get('companies', {owner: this.authInfo.user.id});
      observables.push(companies);
    }
    forkJoin(...observables)
      .subscribe({
        next: result => {
          this.card = result[0].data;
          this.admins = this.authInfo.user.role === 'super' && result[1] ? result[1].data : [];
          this.companies = this.authInfo.user.role === 'admin' && result[1] ? result[1].data : [];
          this.form.patchValue(this.card);
          debugger;
        }
      });

    this.form.get('owner').valueChanges.subscribe(
      {
        next: value => {
          this.getCompanies(value);
        }
      }
    );

  }

  ngOnDestroy(): void {
    super.ngOnDestroy();
  }

  /**
   * Rest
   */

  getCompanies(owner: number): void {
    this.restService.get('companies', {owner})
      .subscribe({
        next: (result: ICompaniesResponse) => {
          this.companies = result.data;
        }
      });
  }

  save(card: ICard): void {

  }

  /**
   * Model changing
   */
  onAdmin(owner: number): void {
    this.form.patchValue({owner});
  }
  onCompany(company: number): void {
    this.form.patchValue({company_id: company});
  }


  /**
   * Actions
   */
  back(): void {
    this.router.navigate([cardsPath]);
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

  /**
   * Misc
   */
  get isSuper(): boolean {
    return this.authInfo.user.role === 'super';
  }

}
