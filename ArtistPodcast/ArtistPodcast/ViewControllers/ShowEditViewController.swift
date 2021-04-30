//
//  ShowEditViewController.swift
//  ArtistPodcast
//
//  Created by apple on 23.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class ShowEditViewController: BaseViewController {

    var show: ShowObject! {
        didSet {
            titleview.value = show.Tittle
            titleview.title = show.Tittle
            descriptionview.title = "Description"
            descriptionview.placeholder = "Description"
            descriptionview.value = show.Description
            datetimeview.value = show.StartDate            
            durationview.value = show.ShowDuration
        }
    }
    
    var states: [StateObject]! {
        didSet {
            
        }
    }

    lazy var titleview : DetailsEditTextfield = {
        let view : DetailsEditTextfield = DetailsEditTextfield(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "venue"
        view.placeholder = "Show title"
        return view
    }()

    lazy var descriptionview : DetailsTextview = {
        let view : DetailsTextview = DetailsTextview(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "info"
        view.placeholder = "View description"
        return view
    }()

    lazy var datetimeview : DetailsDateTime = {
        let view : DetailsDateTime = DetailsDateTime(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = "calendar"
        view.placeholder = "Date & time"
        return view
    }()
    
    lazy var durationview: DetailsDuration = {
       let view : DetailsDuration = DetailsDuration(frame: .zero)
       view.translatesAutoresizingMaskIntoConstraints = false
       view.icon = "time"
       view.placeholder = "Duration"
       return view
    
    }()

    
    override public init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func loadView() {
        super.loadView()
        
        loadSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topBar.dropShadow(color: .black, offSet: CGSize(width: 3,height: 3))

    }
    
    //private UI
    private func loadSubviews() {
        initTopBar()
        initScroller()
        initDetails()
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
        topBar.setLeftButton(image: iconLeft)
        topBar.setTitleLabel(title: "EDIT SHOW")
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
          stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
          stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
          stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func initDetails() {
        stackView.addArrangedSubview(titleview)
        titleview.editable = true
        titleview.expandable = true
        titleview.initialize()
        NSLayoutConstraint.activate([
          titleview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])
        stackView.addArrangedSubview(descriptionview)
        descriptionview.editable = true
        descriptionview.expandable = true
        descriptionview.initialize()
        NSLayoutConstraint.activate([
          descriptionview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])
        
        stackView.addArrangedSubview(datetimeview)
        datetimeview.editable = true
        datetimeview.expandable = true
        datetimeview.initialize()
        NSLayoutConstraint.activate([
          datetimeview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])
        
        stackView.addArrangedSubview(durationview)
        durationview.editable = true
        durationview.expandable = true
        durationview.initialize()
        NSLayoutConstraint.activate([
          durationview.heightAnchor.constraint(equalToConstant: floatDetailsViewHeight),
        ])

    }

}

extension ShowEditViewController: TopBarDelegate {
    func leftClicked() {
        self.pop(animated: true)
    }
    
    func rightClicked() {
    }
}

