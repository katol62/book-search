//
//  ShowDetailsViewController.swift
//  ArtistPodcast
//
//  Created by apple on 20.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class ShowDetailsViewController: BaseViewController {

    var showId: String!
    var states: [StateObject] = [StateObject]()
    
    var listeners: Listeners! {
        didSet {
            listenersDetailsInfoStack.icon = "listeners"
            listenersDetailsInfoStack.title = "\(listeners.listeners)/\(listeners.subscribers)"
            creditsDetailsInfoStack.icon = "credits"
            creditsDetailsInfoStack.title = "\(listeners.purchases) token"
            donatesDetailsInfoStack.icon = "tips"
            donatesDetailsInfoStack.title = "\(listeners.donates) token"
            visibilityDetailsInfoStack.icon = listeners.hidden ? "viewers-hidden" : "viewers-public"
            visibilityDetailsInfoStack.title = listeners.hidden ? "Hidden" : "Public"
            availableDetailsInfoStack.icon = "re-air"
            availableDetailsInfoStack.title = "\(listeners.available) days"
        }
    }
    
    var show: ShowObject! {
        didSet {
            scrollView.isHidden = false

            let localDateString = Helper.DateTimeFormat(date: show!.StartDate, format: "MMM dd, yyyy")
            let localTimeString = Helper.DateTimeFormat(date: show!.StartDate, format: "h:mm a")
            let tz = show!.timeZoneID
            let date = "\(localDateString) - \(localTimeString) (\(tz!))"
            let durationInMins : Int = Helper.hoursStringToMins(hours: show.ShowDuration)
            if durationInMins <= 30 {
                durationview.value = "< 30 minutes"
                durationview.title = "< 30 minutes"
            } else if durationInMins >= 90 {
                durationview.value = "30-90 minutes"
                durationview.title = "30-90 minutes"
            } else {
                durationview.value = "90+ minutes"
                durationview.title = "90+ minutes"
            }

            titleview.value = show.Tittle
            titleview.title = show.Tittle
            locationview.value = "\(show.state ?? ""), \(show.Location ?? "")"
            locationview.title = "\(show.state ?? ""), \(show.Location ?? "")"
            
            dateview.value = date
            dateview.title = date

            creditsview.value = show.Token + " credits"
            creditsview.title = show.Token + " credits"
            
            descriptionview.title = "Description"
            descriptionview.placeholder = "Description"
            descriptionview.value = show.Description
            
            let remaining = Helper.getTimeBeforeNow(startDayString: show.FullStartDate)
            broadcastPlayView.remaining = remaining
            
            broadcastPlayView.isHidden = show.Status != s_SHOW_STATUS_RUNNING
            recordedPlayView.isHidden = show.Status == s_SHOW_STATUS_RUNNING
            if !recordedPlayView.isHidden {
                recordedPlayView.url = URL(string: show.audioStreaming)
            }

        }
    }
    
    //lazy ui elements
    lazy var tabsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var titleview : Details = {
        let view : Details = Details(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "venue"
        view.expandable = false
        return view
    }()

    lazy var locationview : Details = {
        let view : Details = Details(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "location"
        view.expandable = false
        return view
    }()

    lazy var durationview : Details = {
        let view : Details = Details(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "time"
        view.expandable = false
        return view
    }()

    lazy var dateview : Details = {
        let view : Details = Details(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "calendar"
        view.expandable = false
        return view
    }()

    lazy var creditsview : Details = {
        let view : Details = Details(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "credits"
        view.expandable = false
        return view
    }()

    lazy var descriptionview : DetailsTextview = {
        let view : DetailsTextview = DetailsTextview(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "info"
        view.expandable = true
        return view
    }()
    
    lazy var listenersDetailsInfoStack: DetailsInfoStack = {
        let stack: DetailsInfoStack = DetailsInfoStack(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var creditsDetailsInfoStack: DetailsInfoStack = {
        let stack: DetailsInfoStack = DetailsInfoStack(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var donatesDetailsInfoStack: DetailsInfoStack = {
        let stack: DetailsInfoStack = DetailsInfoStack(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var visibilityDetailsInfoStack: DetailsInfoStack = {
        let stack: DetailsInfoStack = DetailsInfoStack(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var availableDetailsInfoStack: DetailsInfoStack = {
        let stack: DetailsInfoStack = DetailsInfoStack(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var broadcastPlayView: BroadcastPlayView = {
        let view: BroadcastPlayView = BroadcastPlayView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var recordedPlayView: RecordedPlayView = {
        let view: RecordedPlayView = RecordedPlayView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title(title: "Share")
        button.addTarget(self, action: #selector(self.onShareClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(Theme.colorTextBase, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = Theme.formButtonBackground
        return button
    }()


    //init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topBar.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))
        descriptionview.addBottomBorderWithColor(color: Theme.colorTextBase, width: 4)
    }
    
    override public init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        getActiveListeners()
        requestDetails()
    }

    override func loadView() {
        super.loadView()
        
        loadSubviews()
    }
    
    private func loadSubviews() {
        initTopBar()
        initScroller()
        initTabsStack()
        initDetails()
        initPlayBlock()
        initShareButton()
        
        scrollView.isHidden = true
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
        let iconLeft = view.getSVGImage(name: "leftarrow")
        let iconRight = view.getSVGImage(name: "edit")
        topBar.setLeftButton(image: iconLeft)
        topBar.setRightButton(image: iconRight)
        topBar.setTitleLabel(title: "SHOW DETAILS")
        topBar.delegate = self
    }
    
    private func initScroller() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.compatibleSafeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
          stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
          stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func initPlayBlock() {
        
        stackView.addArrangedSubview(broadcastPlayView)
        broadcastPlayView.initialize()
        NSLayoutConstraint.activate([
          broadcastPlayView.heightAnchor.constraint(equalToConstant: floatBroadcatsViewHeight),
        ])
        broadcastPlayView.isHidden = true
        
        stackView.addArrangedSubview(recordedPlayView)
        recordedPlayView.initialize()
        NSLayoutConstraint.activate([
          recordedPlayView.heightAnchor.constraint(equalToConstant: floatPlayViewHeight),
        ])
        recordedPlayView.isHidden = true
    }
 
    private func initTabsStack() {
        
        stackView.addArrangedSubview(tabsStackView)
        tabsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabsStackView.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 20),
            tabsStackView.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
            tabsStackView.widthAnchor.constraint(equalToConstant: floatDetailsTabsWidth * 5),
            tabsStackView.heightAnchor.constraint(equalToConstant: floatDetailsTabsHeight),
        ])
        
        tabsStackView.addArrangedSubview(listenersDetailsInfoStack)
        listenersDetailsInfoStack.initialize()
        NSLayoutConstraint.activate([
          tabsStackView.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
        ])

        tabsStackView.addArrangedSubview(creditsDetailsInfoStack)
        creditsDetailsInfoStack.initialize()
        NSLayoutConstraint.activate([
          creditsDetailsInfoStack.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
        ])

        tabsStackView.addArrangedSubview(donatesDetailsInfoStack)
        donatesDetailsInfoStack.initialize()
        NSLayoutConstraint.activate([
          donatesDetailsInfoStack.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
        ])

        tabsStackView.addArrangedSubview(visibilityDetailsInfoStack)
        visibilityDetailsInfoStack.initialize()
        NSLayoutConstraint.activate([
          visibilityDetailsInfoStack.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
        ])

        tabsStackView.addArrangedSubview(availableDetailsInfoStack)
        availableDetailsInfoStack.initialize()
        NSLayoutConstraint.activate([
          availableDetailsInfoStack.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
        ])

    }
    
    private func initDetails() {
        
        stackView.addArrangedSubview(titleview)
        titleview.initialize()
        NSLayoutConstraint.activate([
          titleview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])
        
        stackView.addArrangedSubview(locationview)
        locationview.initialize()
        NSLayoutConstraint.activate([
          locationview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])

        stackView.addArrangedSubview(dateview)
        dateview.initialize()
        NSLayoutConstraint.activate([
          dateview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])

        stackView.addArrangedSubview(durationview)
        durationview.initialize()
        NSLayoutConstraint.activate([
          durationview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])

        stackView.addArrangedSubview(descriptionview)
        descriptionview.editable = false
        descriptionview.initialize()
        NSLayoutConstraint.activate([
          descriptionview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])

    }
    
    private func initShareButton() {
        
        stackView.addArrangedSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.heightAnchor.constraint(equalToConstant: floatTextFieldHeight),
            shareButton.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
        ])

    }
    
    @objc public func onShareClicked(_ sender: UIButton) {
        self.shareHandler()
    }
    
    func shareHandler() {
        print("share handler")
    }


}

extension ShowDetailsViewController: TopBarDelegate {
    func leftClicked() {
        self.pop(animated: true)
    }
    
    func rightClicked() {
        let nc = ShowEditViewController()
        nc.show = show
        nc.states = states
        self.open(ofKind: ShowEditViewController.self, pushController: nc)
    }
}

extension ShowDetailsViewController {
    func requestDetails() {
        let params : [String : String] = [k_SHOW_ID : showId]
        print (params)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        RestClient.get(serviceName: GET_SHOW_DETAILS, parameters: params) { (responce: JSON?, error: NSError?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            }
            else {
                print(responce!)
                if (responce?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                    self.view.makeToast((responce?[k_SERVICE_MESSAGE].stringValue)!)
                }
                else if (responce?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE){
                    
                    let rootJSON = responce?[k_SERVICE_DATA]
                    self.show = ShowObject.build(json: (rootJSON)!)
                    
                }
            }
        }
    }

    @objc func getActiveListeners()  {
        let params: [String : String] = [k_SHOW_ID : showId ]
        RestClient.get(serviceName: GET_LISTENERS_DATA, parameters: params, completionHandler:  { (responce: JSON?, error: NSError?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                print(error?.localizedDescription ?? String())
                return
            }
            else {
                print(responce!)
                if (responce?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_FALSE) {
                    self.view.makeToast((responce?[k_SERVICE_MESSAGE].stringValue)!)
                }
                else if (responce?[k_SERVICE_STATUS].stringValue == SERVICE_STATUS_TRUE){
                    let rootJSON = responce?[k_SERVICE_DATA]
                    self.listeners = Listeners.build(json: (rootJSON)!)
                }
                
//                self.updateListeners()
//                self.stopTimer()
//                self.fireTimer()
                
            }
        })
        
    }

}
