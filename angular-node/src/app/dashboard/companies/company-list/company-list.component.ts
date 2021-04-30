import {ChangeDetectorRef, Component, Injector, OnDestroy, OnInit, QueryList, ViewChild, ViewChildren} from '@angular/core';
import {animate, state, style, transition, trigger} from '@angular/animations';
import {ICompany} from '../../../../../server/models/Company';
import {MatTable, MatTableDataSource} from '@angular/material/table';
import {MatPaginator} from '@angular/material/paginator';
import {RestService} from '../../../shared/services/rest.service';
import {IBaseResponse, ICompaniesResponse} from '../../../../../server/interfaces/http-data';
import {ITerminal} from '../../../../../server/models/Terminal';
import {ICompanyData, ICompanyShort, ITerminalShort} from '../companies.component';
import {BasicComponent} from '../../basic/basic.component';
import {companiesPath, createPath, terminalPath} from '../../../routes';
import {DialogService, IDialogOptions} from '../../../shared/services/dialog.service';
import {IUser} from '../../../../../server/models/User';
import {IMessageItem, NotificationMessageType, NotificationService} from '../../../shared/services/notification.service';

@Component({
  selector: 'app-company-list',
  templateUrl: './company-list.component.html',
  styleUrls: ['./company-list.component.scss'],
  animations: [
    trigger('detailExpand', [
      state('void', style({ height: '0px', minHeight: '0', visibility: 'hidden' })),
      state('*', style({ height: '*', visibility: 'visible' })),
      transition('void <=> *', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})
export class CompanyListComponent extends BasicComponent implements OnInit, OnDestroy {

  protected companies: ICompany[] = [];
  protected companyData: ICompanyData[] = [];

  displayedColumns: string[] = ['name', 'actionsColumn'];
  innerDisplayedColumns: string[] = ['name', 'actionsColumn'];
  dataSource: MatTableDataSource<ICompanyData>;
  expandedElement: ICompanyData | null;

  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;
  @ViewChildren('innerTables') innerTables: QueryList<MatTable<ITerminalShort>>;

  constructor(
    protected injector: Injector,
    private restService: RestService,
    private dialogService: DialogService,
    private notificationService: NotificationService,
    private cd: ChangeDetectorRef
  ) {
    super(injector);
  }

  ngOnInit() {
    super.ngOnInit();
  }

  ngOnDestroy(): void {
    super.ngOnDestroy();
  }

  protected afterInit(): void {
    this.getCompanies();
  }

  getCompanies(): void {
    this.restService.get('companies')
      .subscribe({
        next: (result: ICompaniesResponse) => {
          this.companies = result.data;
          this.processTableData();
        }, error: err => {}
      });
  }

  private processTableData(): void {
    this.companyData = [];
    const tempData: ICompanyShort[] = this.companies.map( (c: ICompany) => ({id: c.id, name: c.name, terminals: c.terminals ? c.terminals : []}));
    tempData.forEach((compData: ICompanyData) => {
      if (compData.terminals && Array.isArray(compData.terminals) && compData.terminals.length) {
        const terminals: ITerminalShort[] = compData.terminals.map((t: ITerminal) => ({id: t.id, name: t.name, company: t.company}));
        this.companyData = [...this.companyData, {...compData, terminals: new MatTableDataSource(terminals)}];
      } else {
        this.companyData = [...this.companyData, {...compData}];
      }
    });
    this.dataSource = new MatTableDataSource<ICompanyData>(this.companyData);
    this.dataSource.paginator = this.paginator;
  }

  toggleRow(element: ICompanyData) {
    if (!element.terminals?.data) {
      return;
    }
    element.terminals && (element.terminals as MatTableDataSource<ITerminalShort>).data.length ? (this.expandedElement = this.expandedElement === element ? null : element) : null;
    this.cd.detectChanges();
  }

  /**
   * Rest
   */

  deleteCompany(company: ICompany): void {
    this.restService.delete('companies/' + String(company.id))
      .subscribe({
        next: (result: IBaseResponse) => {
          const mess: IMessageItem = {
            message: result.message,
            messageType: NotificationMessageType.success};
          this.notificationService.show(mess);
          this.getCompanies();
        }
      });
  }

  doDeleteTerminal(terminal: ITerminalShort): void {
    this.restService.delete('terminals/' + String(terminal.id))
      .subscribe({
        next: (result: IBaseResponse) => {
          const mess: IMessageItem = {
            message: result.message,
            messageType: NotificationMessageType.success};
          this.notificationService.show(mess);
          this.getCompanies();
        }
      });
  }


  /**
   * actions
   */
  delete(item): void {
    const options: IDialogOptions = {
      title: 'Confirm', confirmText: 'OK', message: 'Delete company?'
    };
    this.dialogService.open(options);
    this.dialogService.confirmed().subscribe(confirmed => {
      if (confirmed) {
        this.deleteCompany(item);
      }
    });
  }
  newTerminal(item): void {
    this.router.navigate([companiesPath, item.id, terminalPath, createPath]);

  }

  edit(item: ICompanyShort): void {
    this.router.navigate([companiesPath, item.id], );
  }

  users(item): void {
  }

  newCompany(): void {
    this.router.navigate([companiesPath, 'create']);
  }

  editTerminal(item: ITerminalShort): void {
    this.router.navigate([companiesPath, item.company, terminalPath, item.id]);
  }

  deleteTerminal(item: ITerminalShort): void {
    this.doDeleteTerminal(item);
  }

}
