//
//  ShowDetailsViewController.swift
//  PodcastArtist
//
//  Created by apple on 15.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class ShowDetailsViewController: BaseViewController {

    var finalHeight: CGFloat = 0
    
    weak var detailTitle: ShowDetailView!
    weak var detailLocation: ShowDetailView!

    var show: ShowObject!
    
    public override init(config: NavConfig? = NavConfig()) {
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
        
        addNavButtons()
        addNavTitle(title: "SHOW DETAILS")
        initDetails()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barTop.addBottomBorderWithColor(color: sidemenuColor, width: 1)
        barTop.dropShadow()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        // do it here, after constraints have been materialized
        print("viewDidLayoutSubviews")
    }

    override public func processTouch(touch: UITouch) {
        print("process touch")
    }

    //methods
    override func leftButtonHandler() {
        self.pop(animated: true)
    }
    
    //private ui methods
    private func addNavButtons() {
        let iconLeft = getSVGImage(name: "leftarrow")
        let iconRight = getSVGImage(name: "slidemenu-edit")
        addNavigationButton(type: NavButtonType.left, image: iconLeft)
        addNavigationButton(type: NavButtonType.right, image: iconRight)
    }
    
    private func initDetails() {
        if self.show == nil {
            return
        }
        
        finalHeight = 0
        
        let rct = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: detailsElementHeight)
//        let rct: CGRect = .zero

        let detailTitle = ShowDetailView(frame: rct, details: Element(title: self.show.Tittle, image: "venue", editable: false, expandable: true, type: ElementType.text))
//        detailTitle.details = Element(title: self.show.Tittle, image: "venue", editable: false, expandable: true, type: ElementType.text)
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(detailTitle);
        NSLayoutConstraint.activate([
            detailTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultNavButtonPadding),
            detailTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            detailTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            detailTitle.heightAnchor.constraint(equalToConstant: detailsElementHeight),
        ])
        detailTitle.delegate = self
        self.detailTitle = detailTitle
        
        finalHeight += detailsElementHeight + defaultNavButtonPadding
        
        let locString = "\(self.show.state ?? ""), \(self.show.Location ?? "")"
        let detailLocation = ShowDetailView(frame: rct, details: Element(title: locString, image: "location", editable: false, expandable: true, type: ElementType.text))
//        let detailLocation = ShowDetailView(frame: rct)
//        detailLocation.details = Element(title: locString, image: "location", editable: false, type: ElementType.text)
        detailLocation.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(detailLocation);
        NSLayoutConstraint.activate([
            detailLocation.topAnchor.constraint(equalTo: self.detailTitle.bottomAnchor, constant: defaultNavButtonPadding),
            detailLocation.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            detailLocation.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            detailLocation.heightAnchor.constraint(equalToConstant: detailsElementHeight),
        ])
        detailLocation.delegate = self
        self.detailLocation = detailLocation

        finalHeight += detailsElementHeight + defaultNavButtonPadding
        
        updateHeight(height: finalHeight)
        
    }


}

extension ShowDetailsViewController: ShowDetailViewDelegate {
    func updateInternalHeight(height: CGFloat) {
        finalHeight += height
        updateHeight(height: finalHeight)
    }
    
}
