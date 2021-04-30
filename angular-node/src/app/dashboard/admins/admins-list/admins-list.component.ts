import {Component, Injector, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material/table';
import {IUser} from '../../../../../server/models/User';
import {MatPaginator} from '@angular/material/paginator';
import {BasicComponent} from '../../basic/basic.component';
import {RestService} from '../../../shared/services/rest.service';
import {IAdminsResponse, IBaseResponse, ICompaniesResponse} from '../../../../../server/interfaces/http-data';
import {adminsPath, createPath} from '../../../routes';
import {DialogService, IDialogOptions} from '../../../shared/services/dialog.service';
import {IMessageItem, NotificationMessageType, NotificationService} from '../../../shared/services/notification.service';

@Component({
  selector: 'app-admins-list',
  templateUrl: './admins-list.component.html',
  styleUrls: ['./admins-list.component.scss']
})
export class AdminsListComponent extends BasicComponent implements OnInit {

  protected admins: IUser[];

  displayedColumns: string[] = ['name', 'email', 'role', 'actionsColumn'];
  dataSource: MatTableDataSource<IUser>;

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(
    protected injector: Injector,
    private restService: RestService,
    private dialogService: DialogService,
    private notificationService: NotificationService
  ) {
    super(injector);
  }

  ngOnInit(): void {
    super.ngOnInit();
  }

  protected afterInit(): void {
    this.getAdmins();
  }

  getAdmins(): void {
    this.restService.get('admins')
      .subscribe({
        next: (result: IAdminsResponse) => {
          this.admins = result.data.map((admin: IUser) => ({...admin, name: admin.name + ' ' + admin.last}));
          this.dataSource = new MatTableDataSource<IUser>(this.admins);
          this.dataSource.paginator = this.paginator;
        }, error: err => {}
      });
  }

  deleteAdmin(admin: IUser): void {
    this.restService.delete('admins/' + String(admin.id))
      .subscribe({
        next: (result: IBaseResponse) => {
          const mess: IMessageItem = {
            message: result.message,
            messageType: NotificationMessageType.success};
          this.notificationService.show(mess);
          this.getAdmins();
        }
      });
  }

  /**
   * Actions
   */

  delete(item): void {
    const options: IDialogOptions = {
      title: 'Confirm', confirmText: 'OK', message: 'Delete admin?'
    };
    this.dialogService.open(options);
    this.dialogService.confirmed().subscribe(confirmed => {
      if (confirmed) {
        this.deleteAdmin(item);
      }
    });
  }
  edit(item: IUser): void {
    this.router.navigate([adminsPath, item.id], );
  }

  newAdmin(): void {
    this.router.navigate([adminsPath, createPath]);
  }

}
