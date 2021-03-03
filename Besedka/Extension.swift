//
//  Extension.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import Foundation
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
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.distribution = .equalCentering
        stackView.frame.size = CGSize(width: imageView.frame.width + label.frame.width, height: max(imageView.frame.height, label.frame.height))
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        navigationItem.titleView = stackView

        
    }
    
   
}

extension Date{
    
    func checkDate() -> String{
        let now = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let dayNow = calendar.component(.day, from: now)
        let monthNow = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: self)
        let yearNow = calendar.component(.year, from: now)
        let dateFormatter = DateFormatter()
        
        if month < monthNow || month == monthNow && day < dayNow || year < yearNow{
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: self)
        }else {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }
    }
    
}
