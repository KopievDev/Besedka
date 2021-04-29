//
//  Extension.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

extension UIViewController {
     
    func configureNavigationBar(withTitle title: String, image: UIImage) {
               
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20)
        label.textColor = Theme.current.labelColor
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.distribution = .equalCentering
        stackView.frame.size = CGSize(width: imageView.frame.width + label.frame.width, height: max(imageView.frame.height, label.frame.height))
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        navigationItem.titleView = stackView
        
    }
   
}
