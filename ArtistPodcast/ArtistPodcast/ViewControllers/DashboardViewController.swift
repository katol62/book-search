//
//  DashboardViewController.swift
//  ArtistPodcast
//
//  Created by apple on 20.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class DashboardViewController: BaseViewController {
    
    let typeIncrement = 120
    var listType: ShowsListType = ShowsListType.active;
    var selectedItem: Int = -1
    
    let cellId = "cellId"

    var tabButtons: [UIButton] = [UIButton]()
    
    var showsRunning : [ShowObject] = [ShowObject]()
    var showsReaired : [ShowObject] = [ShowObject]()
    var showsArchived : [ShowObject] = [ShowObject]()
    
    var statesArray: [StateObject] = [StateObject]()

    var refreshControl: UIRefreshControl!
    
    lazy var tabsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 5
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()


    override public init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        loadSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getStates()
        
        topBar.backgroundColor = Theme.colorTopBar
        topBar.delegate = self
        topBar.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))
        
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        showsRunning = [ShowObject]()
        showsReaired = [ShowObject]()
        showsArchived = [ShowObject]()
        updateTable()
        getShows()
    }
    
    private func loadSubviews() {
        
        initTopBar()
        initTabButtons()
        initTable()
        initSideMenu()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view != sideMenu {
            sideMenu.closeMenu()
        }
    }

    
    private func initSideMenu() {
        self.view.addSubview(sideMenu)
        NSLayoutConstraint.activate([
            sideMenu.topAnchor.constraint(equalTo: self.topBar.topAnchor),
            sideMenu.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            sideMenu.widthAnchor.constraint(equalToConstant: floatSideMenuWidth),
            sideMenu.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor),
        ])
        sideMenu.delegate = self
        sideMenu.backgroundColor = Theme.colorMenu
        sideMenu.selectedItem = selectedItem
        sideMenu.initMenu(items: menuArray)

    }
    
    private func initTabButtons() {
        
        let menuItems = NSMutableArray(array: dashboardTabsArray)
        
        self.view.addSubview(tabsStackView)
        NSLayoutConstraint.activate([
            tabsStackView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: defaultNavButtonPadding),
            tabsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tabsStackView.widthAnchor.constraint(equalToConstant: sizeDashboardTabButton.width * 3 + 10),
            tabsStackView.heightAnchor.constraint(equalToConstant: sizeDashboardTabButton.height),
        ])

        var tag = 0
        
        for item in menuItems {
            let arr = item as! NSArray
            let title = arr[0] as! String
            let tab = arr[1] as! ShowsListType
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: sizeDashboardTabButton.width, height: sizeDashboardTabButton.height)
            button.title(title: title)
            button.tag = tag + typeIncrement
            button.addTarget(self, action: #selector(self.tabClicked(_:)), for: .touchUpInside)
            button.setBackgroundImage(UIImage(named: "button-selected"), for: .selected)
            if tab == listType {
                //selected
                button.isSelected = true
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            tabsStackView.addArrangedSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: self.tabsStackView.topAnchor),
                button.bottomAnchor.constraint(equalTo: self.tabsStackView.bottomAnchor),
                button.heightAnchor.constraint(equalToConstant: sizeDashboardTabButton.height),
                button.widthAnchor.constraint(equalToConstant: sizeDashboardTabButton.width),
            ])
            tabButtons.append(button)
            tag += 1
        }

    }

    private func initTopBar() {
        self.view.addSubview(topBar)
        topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: floatTopBarHeight)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: floatTopBarHeight),
        ])
        topBar.backgroundColor = Theme.colorTopBar
        let iconLeft = view.getSVGImage(name: "menu")
        let iconRight = view.getSVGImage(name: "notification")
        topBar.setLeftButton(image: iconLeft)
        topBar.setRightButton(image: iconRight)
        topBar.setTitleLabel(title: "SHOWS")
    }
    
    private func initTable() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.tabsStackView.bottomAnchor, constant: defaultNavButtonPadding),
            tableView.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.backgroundColor = .clear

    }
    
    //refresh control
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        refreshControl.endRefreshing()
        self.getShows()
    }
    
    //click handlers
    private func isMenuOpened() ->Bool {
        return sideMenu.state == MenuState.shown
    }
    
    
    @objc func tabClicked(_ sender: UIButton) {
        
        if isMenuOpened() {
            sideMenu.closeMenu()
            return
        }

        
        print(sender.tag)
        
        let tag = sender.tag - typeIncrement
        self.listType = ShowsListType(rawValue: tag)!
        print(listType)
        for button in tabButtons {
            button.isSelected = false
            if button.tag == sender.tag {
                button.isSelected = true
            }
        }
        updateTable()
    }

    
}

extension DashboardViewController: TopBarDelegate {
    func leftClicked() {
        //side menu
        sideMenu.openMenu()
    }
    
    func rightClicked() {
        if isMenuOpened() {
            sideMenu.closeMenu()
            return
        }
    }
}

extension DashboardViewController: SideMenuDelegate {
    
    func onMenuClosed(action: Action) {
        switch action {
        case Action.logout:
            print(action)
            let nc = LoginViewController()
            self.open(ofKind: LoginViewController.self, pushController: nc)
            break
        case Action.profile:
            print(action)
            break
        case Action.notifications:
            print(action)
            break
        case Action.settings:
            print(action)
            break
        case Action.tech:
            print(action)
            break
        case Action.analytics:
            print(action)
            break
        case Action.shows:
            print(action)
            break
        default:
            print(action)
        }
    }    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func getShow(index: Int) ->ShowObject {
        if listType == ShowsListType.reaired {
            return showsReaired[index]
        } else if listType == ShowsListType.archive {
            return showsArchived[index]
        }
        return showsRunning[index]
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    private func getRowsCount() ->Int {
        if listType == ShowsListType.reaired {
            return showsReaired.count
        } else if listType == ShowsListType.archive {
            return showsArchived.count
        }
        return showsRunning.count
    }
    
    //tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getRowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShowTableViewCell
        
        var show: ShowObject!
        if listType == ShowsListType.reaired {
            show = showsReaired[indexPath.item]
        } else if listType == ShowsListType.archive {
            show = showsArchived[indexPath.item]
        } else {
            show = showsRunning[indexPath.item]
        }
        
        cell.contentView.addBottomBorderWithColor(color: Theme.sidemenuColor, width: 1)
//        cell.contentView.dropShadow(color: .black, offSet: CGSize(width: -1, height: 3))
        
        cell.show = show
        cell.selectionStyle = .none
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return floatShowTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isMenuOpened() {
            return
        }

        print(indexPath.row)
        
        
        let show: ShowObject = getShow(index: indexPath.row) 
        
        let nc = ShowDetailsViewController()
        nc.showId = show.idShow
        nc.states = statesArray
        self.open(ofKind: ShowDetailsViewController.self, pushController: nc)
        
    }

}

extension DashboardViewController {
    //rest api requests
    func getShows() {
        
        var params: [String : String] = [String : String]()
        
        params[k_DJ_ID] = Helper.getValueFromUserDefaultsForKey(key: k_USER_ID)
        params[k_SHOW_TYPE] = s_SHOW_STATUS_RUNNING + "," + s_SHOW_STATUS_END + "," + s_SHOW_STATUS_TIME_END
        params[k_SEARCH_STR] = ""
        
        print(params)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        RestClient.get(serviceName: GET_ARTIST_SHOWS, parameters: params) { (json: JSON?, error: NSError?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            }
            else {
                print(json!)
                if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                    print((json?[k_SERVICE_MESSAGE].stringValue)!)
                }
                else if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE){
                    
                    self.showsRunning = [ShowObject]()
                    self.showsReaired = [ShowObject]()
                    self.showsArchived = [ShowObject]()

                    for _ in 1...8 {
                        for show in (json?[k_SERVICE_DATA].arrayValue)! {
                            let showObject : ShowObject = ShowObject.build(json: show)!
                            
                            if showObject.Status == s_SHOW_STATUS_RUNNING {
                                self.showsRunning.append(showObject)
                            } else if showObject.Status == s_SHOW_STATUS_END {
                                self.showsReaired.append(showObject)
                            } else if showObject.Status == s_SHOW_STATUS_TIME_END && showObject.archive == "1" {
                                self.showsArchived.append(showObject)
                            }
                            self.updateTable()
                        }
                    }
                    self.updateTable()

                }
            }
        }
    }
    
    func getStates() {
        
        let params : [String : String] = [COUNTRY_CODE : "US"]

        RestClient.get(serviceName: GET_STATES, parameters: params) { (json:JSON?, error:NSError?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            }
            else {
                print(json!)
                if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE) {
                    self.statesArray = [StateObject]();
                    
                    for state in (json?[k_SERVICE_DATA].arrayValue)! {
                        let stateObject : StateObject = StateObject.build(json: state)!
                        
                        self.statesArray.append(stateObject)
                    }
                    
                }
                else if (json?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                }
            }
        }
    }

    
}
