import {ChangeDetectorRef, Component, Injector, OnDestroy, OnInit, QueryList, ViewChild, ViewChildren} from '@angular/core';
import {RestService} from '../../shared/services/rest.service';
import {ICompany} from '../../../../server/models/Company';
import {BasicComponent} from '../basic/basic.component';
import {ICompaniesResponse} from '../../../../server/interfaces/http-data';
import {MatTable, MatTableDataSource} from '@angular/material/table';
import {MatPaginator} from '@angular/material/paginator';
import {ITerminal} from '../../../../server/models/Terminal';
import { animate, state, style, transition, trigger } from '@angular/animations';

export interface ITerminalShort {
  id: number;
  company: number;
  name: string;
}

export interface ICompanyShort {
  id: number;
  name: string;
  terminals?: ITerminal[] | MatTableDataSource<ITerminalShort>;
}

export interface ICompanyData {
  id: number;
  name: string;
  terminals?: MatTableDataSource<ITerminalShort>;
}

@Component({
  selector: 'app-companies',
  templateUrl: './companies.component.html',
  styleUrls: ['./companies.component.scss']
})
export class CompaniesComponent implements OnInit, OnDestroy {

  constructor() {}

  ngOnInit() {
  }

  ngOnDestroy(): void {
  }


}
