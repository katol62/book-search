import {Injectable, NgZone} from '@angular/core';
import {Router} from '@angular/router';
import {BehaviorSubject, Observable, Subject} from 'rxjs';
import {delay, filter, map} from 'rxjs/operators';
import {BrowserWindow, BrowserWindowConstructorOptions, IpcRenderer, IpcRendererEvent, Remote} from 'electron';
import * as url from 'url';


export interface ElectronMessage {
    type: 'ConnectionStatus' | 'LobbyNotification' | 'TableIdChanged' | 'Navigate' | 'NotificationError';
    message: any;
}

export interface TableMessage {
    tableId: number;
    message: ElectronMessage;
}

export interface Credentials {
    account: string;
    password: string;
}


/**
 * Look in: mobile_client/platforms/electron/platform_www/cdv-electron-settings.json
 */
@Injectable({
    providedIn: 'root'
})
export class ElectronService {

    private ipc: IpcRenderer | undefined;
    private remote: Remote | undefined;
    private mainWindow: BrowserWindow;
    private main: boolean;

    // Main Window Only
    private tableMap: Map<number, BrowserWindow>;
    private tableNotifications: Subject<TableMessage>;
    private mainNotifications: Subject<ElectronMessage>;

    private initializeSubject: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);
    private credentialsSubject: BehaviorSubject<Credentials[]> = new BehaviorSubject<Credentials[]>([]);

    constructor(private ngZone: NgZone,
                private router: Router) {
    }

    get isElectron(): boolean {
        return !!(window && window.process && window.process.type);
    }

    initialize() {
        if (this.isElectron) {
            if (this.ipc) {
                console.warn('Electron\'s IPC already initialized');
                return;
            }

            try {
                this.ipc = window.require('electron').ipcRenderer;
                this.remote = window.require('electron').remote;

                this.mainWindow = this.remote.getGlobal('mainWindow');
                this.main = this.mainWindow.webContents.id === this.remote.getCurrentWebContents().id;

                if (this.isMain()) {
                    this.getCurrentVersion();
                    this.listenMessages();
                    this.listenCredentials();
                }
                this.initTables();

                this.initializeSubject.next(true);
            } catch (e) {
                console.warn('Electron\'s IPC was not loaded');
            }
        } else {
            console.warn('Electron\'s IPC was not loaded');
        }
    }

    getInitializeObservable(): Observable<boolean> {
        return this.initializeSubject.asObservable();
    }

    isMain(): boolean {
        return this.main;
    }

    isTable(): boolean {
        return !this.main;
    }

    getIpcRenderer(): IpcRenderer | undefined {
        return this.ipc;
    }

    getRemote(): Remote | undefined {
        return this.remote;
    }

    getCurrentVersion() {
        const version: string = this.ipc.sendSync('get-version');
        console.log('Current Version: ', version);
    }

    listenMessages() {
        this.ipc.on('message', (event: IpcRendererEvent, text: string) => console.log('Message: ', text));
    }

    listenCredentials() {
        this.ipc.on('storage-find-credentials-result', (event: IpcRendererEvent, data: Credentials[]) => {
            this.ngZone.run(() => this.credentialsSubject.next(data));
        });
    }

    /**
     * PayPal
     *
     */

    closePayPalWindow() {
        this.ipc.send('close-paypal', {});
    }

    /**
     * Keytar
     *
     */

    setCredentials(account: string, password: string) {
        this.findCredentials()
            .pipe(
                map((list: Credentials[]) => {
                    list.forEach((item: Credentials) => this.deleteCredentials(item.account));
                    return list;
                }),
                delay(1000)
            )
            .subscribe({
                next: () => this.ipc.send('storage-add-credentials', {account, password}),
                error: () => {
                }
            });
    }

    findCredentials(): Observable<Credentials[]> {
        this.ipc.send('storage-find-credentials', {});
        return this.credentialsSubject.asObservable();
    }

    deleteCredentials(account: string) {
        this.ipc.send('storage-delete-credentials', {account});
    }

    /**
     * Tables
     *
     */

    initTables() {
        if (this.isMain()) {
            this.tableMap = new Map<number, BrowserWindow>();
            this.tableNotifications = new Subject<TableMessage>();

            this.listenTableWindows();
        } else {
            this.mainNotifications = new Subject<ElectronMessage>();

            this.listenMainWindow();
        }
    }

    openTable(id: number, name: string, gamePath: string) {
        console.log('Electron. OpenTable id:', id);

        // Check if Window exist
        let tableWindow: BrowserWindow = this.tableMap.get(id);
        if (tableWindow) {
            console.log('Electron. Window exist', id);

            tableWindow.focus();
            return;
        }

        console.log('Electron. Create New Window', id);

        // Create New Window
        tableWindow = new this.remote.BrowserWindow({
            width: 1024,
            height: 768,
            center: true,
            resizable: true,
            frame: true,
            transparent: false,
            title: name,
            // parent: this.mainWindow,
            webPreferences: {
                nodeIntegration: true,
                enableRemoteModule: true
            }
        } as BrowserWindowConstructorOptions);

        const urlToLoad = url.format({
            pathname: __dirname + `/index.html`,
            protocol: 'file:',
            slashes: true,
            hash: '/' + gamePath
        });

        tableWindow.webContents.on('did-finish-load', () => {
            console.log('Table window opened');
            this.ngZone.run(() => this.tableMap.set(id, tableWindow));
        });

        tableWindow.on('closed', () => {
            console.log('Table window closed');
            this.ngZone.run(() => this.tableMap.delete(id));
        });

        tableWindow.loadURL(urlToLoad);
        // tableWindow.webContents.openDevTools();
        tableWindow.setMenuBarVisibility(false);
    }

    closeTable() {
        console.log('Close current window');
        this.remote.getCurrentWindow().close();
    }

    //
    // Main process
    //

    notifyTable(tableId: number, message: ElectronMessage) {
        const gameWindow: BrowserWindow = this.tableMap.get(tableId);
        if (gameWindow) {
            console.log('Send message to table: ' + tableId);
            gameWindow.webContents.send('main-message', message);
        }
    }

    notifyAllTables(message: ElectronMessage) {
        this.tableMap.forEach((gameWindow: BrowserWindow) => gameWindow.webContents.send('main-message', message));
    }

    listenTable(tableId: number): Observable<ElectronMessage> {
        return this.tableNotifications.asObservable()
            .pipe(
                filter((tm: TableMessage) => tm.tableId === tableId),
                map((tm: TableMessage) => tm.message)
            );
    }

    private listenTableWindows() {
        this.ipc.on('table-message', (event: IpcRendererEvent, message: ElectronMessage) => {
            this.ngZone.run(() => this.processTableMessage(event, message));
        });
    }

    private processTableMessage(event: Electron.IpcRendererEvent, message: ElectronMessage) {
        // Find tableId by webContentsId
        let tableId: number;
        let tableWindow: BrowserWindow;
        for (const [key, value] of this.tableMap.entries()) {
            if (value.webContents.id === event.senderId) {
                tableId = key;
                tableWindow = value;
                break;
            }
        }

        if (tableId == null || tableWindow == null) {
            console.log('Warning! Message from undefined table. SenderId: ', event.senderId);
            return;
        }

        console.log('Message from Table( ' + tableId + '): ', message);

        switch (message.type) {
            case 'NotificationError':
                console.log(message.message);
                break;
            case 'TableIdChanged':
                // Refresh TableId
                const newTableId = message.message as number;
                this.tableMap.delete(tableId);
                this.tableMap.set(newTableId, tableWindow);
                break;
            case 'Navigate':
                this.router.navigate(message.message.commands, message.message.extras);
                break;
            default:
                this.tableNotifications.next({tableId, message} as TableMessage);
                break;
        }
    }

    //
    // Table process
    //

    notifyMain(message: ElectronMessage) {
        this.ipc.sendTo(this.mainWindow.webContents.id, 'table-message', message);
    }

    private listenMainWindow() {
        this.ipc.on('main-message', (event: IpcRendererEvent, message: ElectronMessage) => {
            console.log('Message from Main: ', message);
            this.ngZone.run(() => this.mainNotifications.next(message));
        });
    }

    listenMain(): Observable<ElectronMessage> {
        return this.mainNotifications.asObservable();
    }

}
