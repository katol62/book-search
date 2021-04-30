import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {forkJoin, Observable} from 'rxjs';
import {IUser} from '../../../../../server/models/User';
import {BasicComponent} from '../../basic/basic.component';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {RestService} from '../../../shared/services/rest.service';
import {ActivatedRoute} from '@angular/router';
import {IMessageItem, NotificationMessageType, NotificationService} from '../../../shared/services/notification.service';
import {map, startWith} from 'rxjs/operators';
import {IFoc, IRegion, IState} from '../../../../../server/models/Location';
import {
  IAdminsResponse,
  ICompanyResponse,
  ICompanyUpdateRequest,
  ICompanyUpdateResponse,
  ILocationResponse
} from '../../../../../server/interfaces/http-data';
import {MatDatepickerInputEvent} from '@angular/material/datepicker';
import {companiesPath, createPath} from '../../../routes';
import {ValidationService} from '../../../shared/services/validation.service';
import {ICompany} from '../../../../../server/models/Company';
import {IDialogOptions} from '../../../shared/services/dialog.service';

@Component({
  selector: 'app-company-edit',
  templateUrl: './company-edit.component.html',
  styleUrls: ['./company-edit.component.scss']
})
export class CompanyEditComponent extends BasicComponent implements OnInit, OnDestroy {

  public form: FormGroup;
  public id: number;

  admins: IUser[] = [];
  filteredAdmins: Observable<IUser[]>;

  public countries: IState[] = [];
  public focs: IFoc[] = [];
  public regions: IRegion[] = [];

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

  afterInit(): void {
    this.initialActions();
    this.getCountries();
    if (this.authInfo.user.role === 'super') {
      this.getAdmins();
      this.filteredAdmins = this.form.get('owner').valueChanges.pipe(
        startWith<string | IUser>(''),
        map(value => typeof value === 'string' ? value : (<any> value).name),
        map(name => name ? this._filterAdmins(name) : this.admins.slice())
      );
    }
  }

  initialActions(): void {
    this.form = this.formBuilder.group({
      id: [null],
      name: ['', Validators.compose([Validators.required])],
      fullname: [''],
      inn: [''],
      kpp: [''],
      ogrn: [''],
      juradress: [''],
      adress: [''],
      bankdetails: [''],
      nds: [''],
      dogovor: [''],
      dogovordate: [''],
      country: [''],
      foc: [''],
      region: [''],
      owner: [''],
    });

    const id = this.activatedRoute.snapshot.paramMap.get('id');
    if (id) {
      this.id = Number(id);
      this.getCompany(this.id);
    }

    this.form.get('country').valueChanges.subscribe(
      {
        next: value => {
          this.getFoc(value);
        }
      }
    );
    this.form.get('foc').valueChanges.subscribe(
      {
        next: value => {
          this.getRegion(value);
        }
      }
    );
  }

  /**
   * Rest
   */

  getAdmins(): void {
    this.restService.get('admins')
      .subscribe( {
        next: (result: IAdminsResponse) => {
          this.admins = result.data.map((admin: IUser) => ({...admin, name: admin.name + ' ' + admin.last}));
        }
      });
  }

  getCompany(id: number): void {
    this.restService.get('companies/' + String(id))
      .subscribe( {
        next: (result: ICompanyResponse) => {
          const company = result.data;
          this.form.patchValue(company);
          this.form.get('owner').disable();
          this.form.get('country').disable();
          this.form.get('foc').disable();
          this.form.get('region').disable();
        }
      });
  }

  save(company: ICompany): void {
    company = {
      ...company,
      owner: company.owner ? company.owner : this.authInfo.user.id
    };
    const request: ICompanyUpdateRequest = {company};
    if (this.id) {
      this.restService.put('companies/' + String(this.id), request)
        .subscribe( {
          next: (result: ICompanyUpdateResponse) => {
            const mess: IMessageItem = {
              message: result.message,
              messageType: NotificationMessageType.success};
            this.notificationService.show(mess);

          }
        });
    } else {
      this.restService.post('companies/' + createPath, request)
        .subscribe( {
          next: (result: ICompanyUpdateResponse) => {
            const mess: IMessageItem = {
              message: result.message,
              messageType: NotificationMessageType.success};
            this.notificationService.show(mess);
          }
        });
    }
  }

  /**
   * Location - Rest
   */
  getCountries(): void {
    this.restService.get('location/countries')
      .subscribe( {
        next: (result: ILocationResponse) => {
          this.countries = result.items;
        }
      });
  }

  getFoc(id: number): void {
    this.restService.get('location/foc/' + String(id))
      .subscribe( {
        next: (result: ILocationResponse) => {
          this.focs = result.items;
        }
      });
  }

  getRegion(id: number): void {
    this.restService.get('location/region/' + String(id))
      .subscribe( {
        next: (result: ILocationResponse) => {
          this.regions = result.items;
        }
      });
  }

  /**
   * Autocomplete service function
   */
  private _filterAdmins(value: string): IUser[] {
    const filterValue = value.toLowerCase();
    if (filterValue) {
      return this.admins.filter(admin => admin.name.toLowerCase().indexOf(filterValue) !== -1);
    }
    return this.admins;
  }

  nameMapper(id?: number): string | undefined {
    if (this.admins && id !== undefined && id !== null && id > 0) {
      return this.admins.find(admin => admin.id === id).name;
    }
    return undefined;
  }
  displayFn(id ?: number): string | undefined {
    return id ? this.admins.find(a => a.id === id).name : undefined;
  }

  /**
   * Model change
   */
  onCountry(country: number): void {
    this.form.patchValue({country});
  }
  onFoc(foc: number): void {
    this.form.patchValue({foc});
  }
  onRegion(region: number): void {
    this.form.patchValue({region});
  }

  addEvent(type: string, event: MatDatepickerInputEvent<Date>) {}

  /**
   * Actions
   */
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
