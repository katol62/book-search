//
//  DashboardViewController.swift
//  PodcastArtist
//
//  Created by apple on 05.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import Toast_Swift
import MBProgressHUD
import SwiftyJSON

class DashboardViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    weak var tabsBar: UIView!
    weak var tabHolder: UIView!
    weak var tableView: UITableView!

    var listType: ShowsListType = ShowsListType.active;
    
    var showsRunning : [ShowObject] = [ShowObject]()
    var showsReaired : [ShowObject] = [ShowObject]()
    var showsArchived : [ShowObject] = [ShowObject]()
    
    var tabButtons: [UIButton] = [UIButton]()

    fileprivate var tableHeightConstraint: NSLayoutConstraint?

    let cellId = "cellId"
    
    let typeIncrement = 120
    
    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func loadView() {
        super.loadView()
        
        addNavButtons()
        addNavTitle(title: "Shows")

        addTabs()

        addSideMenu(items: menuArray)

        let finalHeight = floatDashboardTopBarHeight
        //final content height
        self.updateHeight(height: finalHeight)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barTop.dropShadow()
        sideMenu.dropShadow()
        
        tabsBar.setGradientBackground()
        tabsBar.dropShadow()
        
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view intrinsic content size: \(view.intrinsicContentSize)")
        print("tabsBar intrinsic content size: \(tabsBar.intrinsicContentSize)")
    }
    
    override public func processTouch(touch: UITouch) {
        if touch.view != sideMenu {
            closeMenu()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        showsRunning = [ShowObject]()
        showsReaired = [ShowObject]()
        showsArchived = [ShowObject]()
        updateTable()
        getShows()
    }

    
    //private ui methods
    private func addNavButtons() {
        addNavButton(type: NavButtonType.left, image: "icon-hamburger")
        addNavButton(type: NavButtonType.right, image: "icon-hamburger")
    }
    
    private func addTabs() {
        
        initTabBar()
        initTabButtons()
        initTableView()
        
    }
    
    private func initTabBar() {
        let bar = UIView(frame: .zero)
        bar.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bar)
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            bar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bar.heightAnchor.constraint(equalToConstant: floatDashboardTopBarHeight),
        ])
        self.tabsBar = bar
        self.contentView.bringSubviewToFront(self.tabsBar)

    }
    
    private func initTabButtons() {
        let menuItems = NSMutableArray(array: dashboardTabsArray)
        
        let tabHolder = UIView(frame: .zero)
        tabHolder.translatesAutoresizingMaskIntoConstraints = false
        self.tabsBar.addSubview(tabHolder)
        NSLayoutConstraint.activate([
            tabHolder.centerXAnchor.constraint(equalTo: self.tabsBar.centerXAnchor),
            tabHolder.centerYAnchor.constraint(equalTo: self.tabsBar.centerYAnchor),
            tabHolder.widthAnchor.constraint(equalToConstant: sizeDashboardTabButton.width * 3),
            tabHolder.heightAnchor.constraint(equalToConstant: sizeDashboardTabButton.height),
        ])
        self.tabHolder = tabHolder

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
            self.tabHolder.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: self.tabHolder.topAnchor),
                button.leadingAnchor.constraint(equalTo: self.tabHolder.leadingAnchor, constant: CGFloat(tag) * sizeDashboardTabButton.width),
                button.heightAnchor.constraint(equalToConstant: sizeDashboardTabButton.height),
                button.widthAnchor.constraint(equalToConstant: sizeDashboardTabButton.width),
            ])
            tabButtons.append(button)
            self.tabHolder.bringSubviewToFront(button)
            tag += 1
        }

    }
    
    private func initTableView() {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(table)
        tableHeightConstraint = table.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.tabsBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.tableHeightConstraint!
        ])
        self.tableView = table
        self.tableView.backgroundColor = .clear
    }
    
    private func updateUi() {
        
        //update of height to scroll tableview
        let finalHeight = self.view.bounds.height - floatDashboardTopBarHeight - barTop.frame.size.height

        NSLayoutConstraint.deactivate([self.tableHeightConstraint!])
        self.tableHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: finalHeight)
        NSLayoutConstraint.activate([self.tableHeightConstraint!])
        self.tableView.setNeedsLayout()

        print(self.view.bounds.height)
        self.updateHeight(height: finalHeight)
        
        self.scrollView.isScrollEnabled = false
        self.tableView.isScrollEnabled = true

    }
    
    //click handlers
    @objc func tabClicked(_ sender: UIButton) {
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

        
    override func leftButtonHandler() {
        toggleMenu()
    }
    
    override func closeButtonHandler() {
        toggleMenu()
    }
    
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

//                    for show in (json?[k_SERVICE_DATA].arrayValue)! {
//                        let showObject : ShowObject = ShowObject.build(json: show)!
//
//                        if showObject.Status == s_SHOW_STATUS_RUNNING {
//                            self.showsRunning.append(showObject)
//                        } else if showObject.Status == s_SHOW_STATUS_END {
//                            self.showsReaired.append(showObject)
//                        } else if showObject.Status == s_SHOW_STATUS_TIME_END && showObject.archive == "1" {
//                            self.showsArchived.append(showObject)
//                        }
//                        self.updateTable()
//                    }
                }
            }
        }
    }
    
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
        self.updateUi()
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
        print(indexPath.row)
        
        let show: ShowObject = getShow(index: indexPath.row)
        
        let config = NavConfig(top: true)
        let nc = ShowDetailsViewController(config: config)
        nc.show = show
        self.open(ofKind: ShowDetailsViewController.self, pushController: nc)
        
    }
}

