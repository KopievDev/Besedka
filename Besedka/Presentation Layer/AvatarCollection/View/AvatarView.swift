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
        button.setImage(UIImage(named: "close"), for: .normal)
        button.setImage(UIImage(named: "closeTap"), for: .highlighted)
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
        textfield.attributedPlaceholder = NSAttributedString(string: "Тема для поиска",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        image.image = UIImage(named: "eclipce")
        image.tintColor = Theme.current.labelColor
        textfield.leftView = image
        textfield.textAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.translatesAutoresizingMaskIntoConstraints = false
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
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            
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
