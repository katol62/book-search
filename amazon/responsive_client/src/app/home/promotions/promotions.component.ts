import {Component, HostListener, Input, NgZone, OnInit} from '@angular/core';
import {IPromotion, PromotionService} from '../promotion.service';
import {DomSanitizer, SafeResourceUrl} from '@angular/platform-browser';


@Component({
    selector: 'app-promotions',
    templateUrl: './promotions.component.html',
    styleUrls: ['./promotions.component.scss']
})
export class PromotionsComponent implements OnInit {

    @Input('promotions')
    public set promotions(items: IPromotion[]) {
        if (items) {
            this.slides = items;
            this.adjustsItemsPerSlide();
        }
    }

    constructor(private promotionService: PromotionService,
                private zone: NgZone,
                private sanitizer: DomSanitizer) {
    }

    public slides: IPromotion[] = [];
    public itemsPerSlide = 3;
    public singleSlideOffset = true;
    public noWrap = true;

    private innerWidth: number;
    private mobileMiddleBreakpoint = 768;
    private mobileBreakpoint = 480;

    @HostListener('window:resize', ['$event'])
    public sizeChange(event) {
        console.log('size changed.', event);
        this.adjustsItemsPerSlide();
    }

    @HostListener('window:orientationchange', ['$event'])
    public orientationChange(event) {
        console.log('orientation changed.', event);
        window.location.reload();
    }

    ngOnInit(): void {}

    onSlideRangeChange(indexes: number[]): void {
        console.log(`Slides have been switched: ${indexes}`);
    }

    private adjustsItemsPerSlide() {
        this.innerWidth = window.innerWidth;
        if (this.innerWidth < this.mobileBreakpoint) {
            this.itemsPerSlide = 1;
        } else if (this.innerWidth <= this.mobileMiddleBreakpoint && this.innerWidth > this.mobileBreakpoint) {
            this.itemsPerSlide = 2;
        } else {
            this.itemsPerSlide = 3;
        }
    }

    safeUrl(url: string): SafeResourceUrl {
        return this.sanitizer.bypassSecurityTrustResourceUrl(url);
    }

}
