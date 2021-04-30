import {ApplicationRef, Component, ComponentFactoryResolver, Injector, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {CdkPortal, DomPortalOutlet} from '@angular/cdk/portal';

/**
 * https://medium.com/@saranya.thangaraj/open-angular-component-in-a-new-tab-without-bootstrapping-the-whole-app-again-e329af460e92
 */
@Component({
    selector: 'window-portal',
    template: `
        <ng-container *cdkPortal>
            <ng-content></ng-content>
        </ng-container>
    `
})
export class WindowPortalComponent implements OnInit, OnDestroy {

    @ViewChild(CdkPortal, {static: true})
    public portal: CdkPortal;

    private externalWindow: Window = null;
    private styleSheetElement: HTMLElement;

    constructor(private componentFactoryResolver: ComponentFactoryResolver,
                private applicationRef: ApplicationRef,
                private injector: Injector) {
    }

    ngOnInit() {
        this.externalWindow = window.open('', 'Game', 'width=600,height=400,left=200,top=200,toolbar=0,resizable=1');

        // if (this.externalWindow.location.href === 'about:blank') {
        //     this.externalWindow.location.href = 'assets/modal/popout.html';
        // }

        // Wait for window instance to be created
        setTimeout(() => this.createCDKPortal(), 4000);
    }

    private createCDKPortal() {
        // Create a PortalOutlet with the body of the new window document
        const outlet = new DomPortalOutlet(
            this.externalWindow.document.body,
            this.componentFactoryResolver,
            this.applicationRef,
            this.injector);

        // Copy styles from parent window
        // document.querySelectorAll('link, style').forEach(htmlElement => {
        //     this.externalWindow.document.head.appendChild(htmlElement.cloneNode(true));
        // });

        document.querySelectorAll('style').forEach(htmlElement => {
            this.externalWindow.document.head.appendChild(htmlElement.cloneNode(true));
        });

        // Copy stylesheet link from parent window
        this.styleSheetElement = this.getStyleSheetElement();
        this.externalWindow.document.head.appendChild(this.styleSheetElement);

        outlet.attach(this.portal);
    }

    private getStyleSheetElement(): HTMLElement {
        const styleSheetElement = document.createElement('link');
        document.querySelectorAll('link').forEach(htmlElement => {
            if (htmlElement.rel === 'stylesheet') {
                const absoluteUrl = new URL(htmlElement.href).href;
                styleSheetElement.rel = 'stylesheet';
                styleSheetElement.href = absoluteUrl;
            }
        });

        console.log(styleSheetElement.sheet);

        return styleSheetElement;
    }

    ngOnDestroy() {
        this.externalWindow.close();
    }
}
