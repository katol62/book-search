import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { HomeRoutingModule } from './home-routing.module';
import { HomeComponent } from './home.component';
import {SharedModule} from '../shared/shared.module';
import { PromotionsComponent } from './promotions/promotions.component';
import {CarouselModule} from 'ngx-bootstrap';
import {PromotionService} from './promotion.service';
import { NewsComponent } from './news/news.component';


@NgModule({
    declarations: [HomeComponent, PromotionsComponent, NewsComponent],
    imports: [
        CommonModule,
        CarouselModule,
        SharedModule,
        HomeRoutingModule
    ],
    providers: [
        PromotionService
    ]
})
export class HomeModule { }
