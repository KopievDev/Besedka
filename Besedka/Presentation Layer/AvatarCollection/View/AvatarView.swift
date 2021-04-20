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
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
//        let collection = UICollectionView(frame: CGRect(x: 0, y: searchImage.frame.maxY + 10,
//                                                        width: self.frame.width,
//                                                        height: self.frame.height * 6 / 7),
//                                          collectionViewLayout: layout)
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
        label.text = "Найди свой аватар"
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
    
    lazy var searchImage: UITextField = {
        let textfield = UITextField()
        textfield.font = .systemFont(ofSize: 16)
        textfield.attributedPlaceholder = NSAttributedString(string: "Поиск изображений",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        textfield.addBorderLine(color: Theme.current.secondaryLabelColor)
        textfield.addCornerRadius(8)
        textfield.clearButtonMode = .whileEditing
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textfield.leftViewMode = .always
        textfield.keyboardType = .alphabet
        return textfield
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
        addSubview(searchImage)
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
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            searchImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            searchImage.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -100),
            searchImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            avatarCollection.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 10),
            avatarCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            avatarCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            avatarCollection.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)

        ])
    }

}
