import {Component, Injector, OnDestroy, OnInit} from '@angular/core';
import {NavMenuContainerComponent} from '../shared/nav-menu-container/nav-menu-container.component';
import {ELobbyMenuType, ILobbuMenu} from '../shared/lobby-menu/lobby-menu-item';
import {LoginResponse} from '../shared/messages/login';
import {UserSettingsResponse} from '../shared/messages/usersettings';
import {combineLatest, Subscription} from 'rxjs';
import {AccountService} from '../shared/services/account.service';
import {SettingsService} from '../shared/services/settings.service';
import {LobbyRestService} from '../shared/rest-services/lobby-rest.service';
import {LobbyNotificationRestService} from '../shared/rest-services/notification/lobby-notification-rest.service';
import {TourneyComparerService} from '../lobby/utils/tourney-comparer.service';
import {SessionStorageService} from '../shared/storage/session-storage.service';
import {ActivatedRoute} from '@angular/router';
import {MenuItems} from '../shared/lobby-menu/lobby-menu-nav/lobby-menu-nav.component';
import {lobbyPath} from '../routes';
import {IPromotion, PromotionService} from './promotion.service';
import {DomSanitizer, SafeResourceUrl} from '@angular/platform-browser';

@Component({
    selector: 'app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent extends NavMenuContainerComponent implements OnInit, OnDestroy {

    public promotions: IPromotion[] = [];
    public news: IPromotion[] = [];
    public lobbyMenuItems: ILobbuMenu[];

    public authData: LoginResponse;
    public userSettings: UserSettingsResponse;

    private accountSubscription: Subscription;
    private notificationSubscription: Subscription;
    public mobile: boolean;

    constructor(
        protected injector: Injector,
        private accountService: AccountService,
        private settingsService: SettingsService,
        private promotionService: PromotionService,
        private sanitizer: DomSanitizer) {

        super(injector);
        this.lobbyMenuItems = MenuItems.filter((item: ILobbuMenu) => this.logService.idDebug() || item.type !== ELobbyMenuType.RECORDED_GAMES).map((item: ILobbuMenu) => ({...item, disabled: item.type === ELobbyMenuType.HOME}));
        this.mobile = this.deviceDetectorService.isMobile();
    }

    ngOnInit(): void {
        this.accountSubscription = combineLatest([
            this.accountService.authDataLiveState(),
            this.settingsService.settingsLiveState()
        ]).subscribe({
            next: ([authData, userSettings]: [LoginResponse, UserSettingsResponse]) => {
                this.authData = authData;
                this.userSettings = userSettings;
            }
        });
        this.loadData();
    }

    ngOnDestroy(): void {
        if (this.accountSubscription) {
            this.accountSubscription.unsubscribe();
        }
        if (this.notificationSubscription) {
            this.notificationSubscription.unsubscribe();
        }
    }

    /**
     * Actions
     */

    proceed(): void {
        this.router.navigate([lobbyPath]);
    }

    onLogout() {
        this.accountService.logout().subscribe(() => {
        });
    }

    /**
     * Data
     */
    private loadData(): void {
        this.promotionService.loadAmazon().subscribe({
            next: res => {
                this.promotions = res.promotions ? res.promotions.map((item: IPromotion) => ({...item, sanUrl: this.safeUrl(item.url)})) : [];
                this.news = res.news ? res.news.map((item: IPromotion) => ({...item, sanUrl: this.safeUrl(item.url)})) : [];
            },
            error: err => {
                console.log(err);
            }
        });
    }

    private safeUrl(url: string): SafeResourceUrl {
        return this.sanitizer.bypassSecurityTrustResourceUrl(url);
    }


}
