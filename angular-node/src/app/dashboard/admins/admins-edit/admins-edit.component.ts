import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {BasicComponent} from '../../basic/basic.component';
import {RestService} from '../../../shared/services/rest.service';
import {ActivatedRoute} from '@angular/router';
import {IAdminResponse, IAdminUpdateRequest, IAdminUpdateResponse} from '../../../../../server/interfaces/http-data';
import {adminsPath, createPath} from '../../../routes';
import {IUser} from '../../../../../server/models/User';
import {IMessageItem, NotificationMessageType, NotificationService} from '../../../shared/services/notification.service';
import {ValidationService} from '../../../shared/services/validation.service';

@Component({
  selector: 'app-admins-edit',
  templateUrl: './admins-edit.component.html',
  styleUrls: ['./admins-edit.component.scss']
})
export class AdminsEditComponent extends BasicComponent implements OnInit, OnDestroy {

  public form: FormGroup;
  public id: number;

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
    this.form = this.formBuilder.group({
      id: [null],
      name: ['', Validators.compose([Validators.required])],
      last: ['', Validators.compose([Validators.required])],
      phone: [''],
      email: ['', Validators.compose([Validators.required, Validators.email])],
      password: [''],
      confirmPassword: [''],
      publisher: [''],
      isPublisher: [false],
    });

    const id = this.activatedRoute.snapshot.paramMap.get('id');
    if (id) {
      this.id = Number(id);
      this.getAdmin(this.id);
      this.form.get('password').setErrors(null);
      this.form.get('confirmPassword').setErrors(null);
      this.form.get('password').setValidators(null);
      this.form.get('confirmPassword').setValidators(null);
    } else {
      this.form.get('password').setValidators([Validators.required, Validators.minLength(3)]);
      this.form.get('confirmPassword').setValidators([Validators.required, Validators.minLength(3), ValidationService.compare('password')]);
    }

    this.form.get('password').valueChanges.subscribe((change) => {
      if (this.id) {
        if (this.form.get('password').value !== '') {
          this.form.get('password').setValidators([Validators.required, Validators.minLength(3)]);
          this.form.get('confirmPassword').setValidators([Validators.required, Validators.minLength(3), ValidationService.compare('password')]);
        } else {
          this.form.get('password').setErrors(null);
          this.form.get('confirmPassword').setErrors(null);
          this.form.get('password').setValidators(null);
          this.form.get('confirmPassword').setValidators(null);
        }
      }
    });
  }

  protected afterInit(): void {
  }

  ngOnDestroy(): void {
    super.ngOnDestroy();
  }

  getAdmin(id: number): void {
    this.restService.get('admins/' + id.toString()).subscribe({
        next: (value: IAdminResponse) => {
          this.form.patchValue(value.data);
          this.form.patchValue({isPublisher: value.data.publisher === '1'});
        }
      }
    );
  }

  save(admin: IUser): void {
    const adm: IUser = {...admin, publisher: this.form.get('isPublisher').value === true ? '1' : '0'};
    const adminRequest: IAdminUpdateRequest = {admin: adm};
    if (admin.id) {
      this.restService.put('admins/' + String(admin.id), adminRequest)
        .subscribe({
          next: (value: IAdminUpdateResponse) => {
            const mess: IMessageItem = {
              message: value.message,
              messageType: NotificationMessageType.success};
            this.notificationService.show(mess);
          }
        });
    } else {
      this.restService.post('admins/' + createPath, adminRequest)
        .subscribe({
          next: (value: IAdminUpdateResponse) => {
            const mess: IMessageItem = {
              message: value.message,
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

  public errorHandling = (control: string, error: string) => {
    return this.form.controls[control].hasError(error);
  }

  back(): void {
    this.router.navigate([adminsPath]);
  }

}
