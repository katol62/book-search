import {AfterViewInit, Component, Injector, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ICard} from '../../../../../server/models/Card';
import {MatTableDataSource} from '@angular/material/table';
import {BasicComponent} from '../../basic/basic.component';
import {RestService} from '../../../shared/services/rest.service';
import {DialogService} from '../../../shared/services/dialog.service';
import {NotificationService} from '../../../shared/services/notification.service';
import {IBaseResponse, IPaging} from '../../../../../server/interfaces/http-data';
import {MatPaginator} from '@angular/material/paginator';
import {IUser} from '../../../../../server/models/User';
import {MatSort} from '@angular/material/sort';
import {InfoService, ISheetData} from '../../../shared/services/info.service';

@Component({
  selector: 'app-cards-list',
  templateUrl: './cards-list.component.html',
  styleUrls: ['./cards-list.component.scss']
})
export class CardsListComponent extends BasicComponent implements OnInit, OnDestroy, AfterViewInit {

  protected cards: ICard[];
  public displayedColumns: string[] = ['card_nb', 'type', 'status', 'lifetime', 'actionsColumn'];
  dataSource: MatTableDataSource<ICard>;
  resultsLength = 0;
  private filter = '';
  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(
    protected injector: Injector,
    private restService: RestService,
    private dialogService: DialogService,
    private notificationService: NotificationService,
    private infoService: InfoService
  ) {
    super(injector);
  }

  ngAfterViewInit(): void {
    this.sort.sortChange.subscribe(() => {
      this.paginator.pageIndex = 0;
      this.getCards();
    });
    this.getCards();
  }

  ngOnInit(): void {
    super.ngOnInit();
  }

  ngOnDestroy(): void {
    super.ngOnDestroy();
  }

  protected afterInit(): void {
  }

  /**
   * Rest
   */
  getCards(): void {
    const filter = {filter: this.filter ? this.filter : ''};
    const paging: IPaging = {offset: this.paginator.pageIndex, limit: this.paginator.pageSize};
    const sort = {sort: this.sort.active ? this.sort.active : 'id', direction: this.sort.direction ? this.sort.direction : 'asc'};
    const params = {...paging, ...filter, ...sort};
    this.restService.get('/cards', params)
      .subscribe({
        next: (response: IBaseResponse) => {
          this.cards = response.data.data;
          this.resultsLength = response.data.total;
          if (!this.dataSource) {
            this.dataSource = new MatTableDataSource<ICard>(this.cards);
          } else {
            this.dataSource.data = this.cards;
          }
        }
      });
  }


  /**
   * Actions
   */
  onPaginateChange(event): void {
    this.getCards();
  }
  applyFilter(filterValue: string) {
    this.filter = filterValue.trim().toLowerCase();
    this.getCards();
  }

  newCard(): void {
  }
  delete(item: ICard): void {
  }
  edit(item: ICard): void {
    this.router.navigate(['cards', item.id]);
  }
  details(item: ICard): void {
    const exclude = ['transh', 'company_id', 'pass', 'owner', 'test', 'update_date', 'updated_by', 'date_pass', 'date_pass_update', 'date_discount', 'pass_count', 'pass_total'];
    const items = Object.keys(item).filter(key => (exclude.indexOf(key) === -1)).map(key => ({key: String(key), value: item[key]}));
    const config: ISheetData = {
      title: String(item.card_nb),
      infoItems: items
    };
    this.infoService.open(config);
  }

}
