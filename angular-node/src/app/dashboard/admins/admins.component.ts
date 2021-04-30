import {Component, Injector, OnInit} from '@angular/core';
import {BasicComponent} from '../basic/basic.component';
import {RestService} from '../../shared/services/rest.service';

@Component({
  selector: 'app-admins',
  templateUrl: './admins.component.html',
  styleUrls: ['./admins.component.scss']
})
export class AdminsComponent implements OnInit {

  constructor() {
  }

  ngOnInit(): void {
  }

}
