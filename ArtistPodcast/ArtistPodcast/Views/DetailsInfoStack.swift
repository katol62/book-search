//
//  DetailsInfoStack.swift
//  ArtistPodcast
//
//  Created by apple on 22.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit

class DetailsInfoStack: UIStackView {
    
    var icon: String = "" {
        didSet {
            let image: UIImage = getSVGImage(name: icon)
            let imageColored: UIImage = changeTintColorWithImage(img: image, tintColor: Theme.colorViolet)
            imageView.contentMode = .scaleAspectFit
            imageView.image = imageColored

        }
    }
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv: UIImageView = UIImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var label: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = Theme.colorCellText
        label.backgroundColor = .clear
        return label
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initialize() {
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 10
        self.distribution = .fill
        
        addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
          imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
          imageView.widthAnchor.constraint(equalToConstant: sizeDetailsIcon.width),
          imageView.heightAnchor.constraint(equalToConstant: sizeDetailsIcon.height)
        ])

        addArrangedSubview(label)
        NSLayoutConstraint.activate([
          label.centerXAnchor.constraint(equalTo: centerXAnchor),
          label.widthAnchor.constraint(equalToConstant: sizeDetailsLabel.width),
          label.heightAnchor.constraint(equalToConstant: sizeDetailsLabel.height)
        ])

    }
    

}
