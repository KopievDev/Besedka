//
//  AvatarCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    // MARK: - Properties
    var imageUrl: String? {
            didSet {
                configure()
            }
        }
    
    // avatar
    let avatarImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(named: "placeholder")
        iv.layer.cornerRadius = 48 / 2
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.color = Theme.current.bubbleFromMe
        ind.hidesWhenStopped = true
        ind.translatesAutoresizingMaskIntoConstraints = false
        return ind
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configure() {
        guard let url = imageUrl else {return}
        self.indicator.startAnimating()
        self.avatarImageView.loadImageWithUrl(urlString: url) {
            self.indicator.stopAnimating()
        }
        
//        self.avatarImageView.image = UIImage(named: "placeholder")
//        let network = Network()
//        network.getImageCache(url) {[weak self] image in
//            guard let `self` = self else {return}
//            self.avatarImageView.transition(to: image)
//            self.indicator.stopAnimating()
//        }

    }
    private func createUI() {
        addSubview(avatarImageView)
        addSubview(indicator)
        createConstrains()
    }
    private func createConstrains() {
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: self.heightAnchor),
            
            indicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 30),
            indicator.widthAnchor.constraint(equalTo: indicator.heightAnchor)
        ])
    }
}
