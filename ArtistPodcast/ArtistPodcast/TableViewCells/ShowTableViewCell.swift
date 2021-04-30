//
//  ShowTableViewCell.swift
//  ArtistPodcast
//
//  Created by apple on 20.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import SVGKit

class ShowTableViewCell: UITableViewCell {

    var show : ShowObject? {
        didSet {
            let localDateString = Helper.DateTimeFormat(date: show!.StartDate, format: "MMM dd, yyyy")
            let localTimeString = Helper.DateTimeFormat(date: show!.StartDate, format: "h:mm a")
            let tz = show!.timeZoneID
            let date = "\(localDateString) - \(localTimeString) (\(tz!))"

            showNameLabel.text = show!.Tittle
            showDateLabel.text = date
            showLocationLabel.text = show!.state + ", " + show!.Location
            showListenersLabel.text = "0"
            showCreditsLabel.text = show!.Token
        }
    }

    private let showNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = Theme.colorTextBase
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let showDateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = Theme.colorCellText
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let showLocationLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = Theme.colorCellText
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let showListenersLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = Theme.colorCellText
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let showListenersImage : UIImageView = {
        let imgv = UIImageView()
        let namSvgImgVar: SVGKImage = SVGKImage(named: "listeners")
        let namImjVar: UIImage = namSvgImgVar.uiImage
        imgv.image = namImjVar
        imgv.contentMode = .scaleAspectFit
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()

    private let showCreditsLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = Theme.colorCellText
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let showCreditsImage : UIImageView = {
        let imgv = UIImageView()
        let namSvgImgVar: SVGKImage = SVGKImage(named: "crediticon")
        let namImjVar: UIImage = namSvgImgVar.uiImage
        imgv.image = namImjVar
        imgv.contentMode = .scaleAspectFit
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.backgroundColor = Theme.colorBackground
        self.contentView.backgroundColor = Theme.colorBackground

        self.contentView.addSubview(showNameLabel)
        self.contentView.addSubview(showDateLabel)
        self.contentView.addSubview(showLocationLabel)
        self.contentView.addSubview(showListenersImage)
        self.contentView.addSubview(showListenersLabel)
        self.contentView.addSubview(showListenersImage)
        self.contentView.addSubview(showCreditsImage)
        self.contentView.addSubview(showCreditsLabel)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        let stackCreditsView = UIStackView(arrangedSubviews: [showCreditsImage, showCreditsLabel])
        stackCreditsView.translatesAutoresizingMaskIntoConstraints = false
        stackCreditsView.distribution = .equalSpacing
        stackCreditsView.axis = .vertical
        stackCreditsView.spacing = 5
        stackCreditsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackCreditsView)
        NSLayoutConstraint.activate([
            stackCreditsView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            stackCreditsView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            stackCreditsView.widthAnchor.constraint(equalToConstant: 60),
            stackCreditsView.heightAnchor.constraint(equalToConstant: 60),
        ])

        let stackListenersView = UIStackView(arrangedSubviews: [showListenersImage, showListenersLabel])
        stackListenersView.translatesAutoresizingMaskIntoConstraints = false
        stackListenersView.distribution = .equalSpacing
        stackListenersView.axis = .vertical
        stackListenersView.spacing = 5
        stackListenersView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackListenersView)
        NSLayoutConstraint.activate([
            stackListenersView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            stackListenersView.rightAnchor.constraint(equalTo: stackCreditsView.leftAnchor),
            stackListenersView.widthAnchor.constraint(equalToConstant: 60),
            stackListenersView.heightAnchor.constraint(equalToConstant: 60),
        ])

        NSLayoutConstraint.activate([
            showDateLabel.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            showDateLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            showDateLabel.rightAnchor.constraint(equalTo: stackListenersView.leftAnchor),
            showDateLabel.heightAnchor.constraint(equalToConstant: 24),
        ])

        NSLayoutConstraint.activate([
            showNameLabel.bottomAnchor.constraint(equalTo: showDateLabel.topAnchor),
            showNameLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            showNameLabel.rightAnchor.constraint(equalTo: stackListenersView.leftAnchor),
            showNameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])

        NSLayoutConstraint.activate([
            showLocationLabel.topAnchor.constraint(equalTo: showDateLabel.bottomAnchor),
            showLocationLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            showLocationLabel.rightAnchor.constraint(equalTo: stackListenersView.leftAnchor),
            showLocationLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = selected ? Theme.colorMenuSelectedTransparent : .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.contentView.backgroundColor = highlighted ? Theme.colorMenuSelectedSemitransparent : .clear
    }
}
