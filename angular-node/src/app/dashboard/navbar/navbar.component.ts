import {Component, Input, OnInit} from '@angular/core';
import {ENavbarType, INavbarItem} from './navbar-models';
import {adminsPath, cardsPath, companiesPath, homePath, loginPath} from '../../routes';
import {NavigationEnd, Router, RouterEvent} from '@angular/router';
import {AuthService} from '../../shared/services/auth.service';
import {IAuthResponse} from '../../../../server/interfaces/http-data';

const tabs = [
  {id: ENavbarType.home, label: 'Home', path: [homePath], roles: []},
  {id: ENavbarType.companies, label: 'Companies', path: [companiesPath], roles: []},
  {id: ENavbarType.admins, label: 'Admins', path: [adminsPath], roles: ['super']},
  {id: ENavbarType.cards, label: 'Cards', path: [cardsPath], roles: ['super', 'admin']},
] as INavbarItem[];


@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent {

  @Input()
  public set authInfo(authInfo: IAuthResponse) {
    if (authInfo) {
      this.tabItems = tabs.filter(tab => (!tab.roles.length || (tab.roles.length && tab.roles.indexOf(authInfo.user.role) !== -1)))
    }
  }

  private type = ENavbarType;

  public selectedTab: ENavbarType = ENavbarType.home;
  public tabItems: INavbarItem[] = [];

  constructor(
    private router: Router,
    private authService: AuthService
  ) {
    router.events.subscribe((val: RouterEvent) => {
      if (val instanceof NavigationEnd) {
        const [, ...rest] = router.url.split('?')[0].split('/');
        this.selectedTab = this.type[rest[0]];
      }
    });
  }

  selectTab(tab: INavbarItem): void {
    this.selectedTab = tab.id;
    this.router.navigate(tab.path);
  }

  logout(): void {
    this.authService.onLogout();
    this.router.navigate([loginPath]);
  }

}
