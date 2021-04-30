import {Component, Input, OnInit} from '@angular/core';
import {IPromotion} from '../promotion.service';

@Component({
    selector: 'app-news',
    templateUrl: './news.component.html',
    styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

    public news: IPromotion[] = [];
    @Input('newsItems')
    public set newsItems(items: IPromotion[]) {
        this.news = items;
    }


    constructor() { }

    ngOnInit(): void {
    }

}
