//
//  AvatarView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 19.04.2021.
//

import UIKit

class AvatarView: UIView {
    // MARK: - Properties
    let cellId = "cellAvatar"
    lazy var avatarCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = (self.frame.width - 40) / 3
        layout.itemSize = CGSize(width: width, height: width)
        let collection = UICollectionView(frame: CGRect(x: 0, y: self.frame.height / 7,
                                                        width: self.frame.width,
                                                        height: self.frame.height * 6 / 7),
                                          collectionViewLayout: layout)
        collection.register(AvatarCell.self, forCellWithReuseIdentifier: cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        return refreshControl
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(Theme.current.labelColor, for: .normal)
        button.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "Images"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = Theme.current.bubbleFromMe
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func createDesign() {
        backgroundColor = Theme.current.backgroundColor
        addSubview(avatarCollection)
        addSubview(indicator)
        addSubview(closeButton)
        addSubview(titleLabel)
        avatarCollection.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 30),
            indicator.widthAnchor.constraint(equalToConstant: 30),
            
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
            
        ])
    }

}
