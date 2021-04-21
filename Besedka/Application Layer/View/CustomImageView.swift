//
//  CustomImageView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

class CustomImageView: UIImageView {
    
    private var currentTask: URLSessionTask?
    var imageUrlString: String?
    
    func loadImageWithUrl(urlString: String, _ completion: @escaping () -> Void) {
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        imageUrlString = urlString
        
        image = UIImage(named: "placeholder")
        
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            setImage(image: cachedImage, canAnimate: true)
            completion()
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, error) in
           guard let `data` = data,
                 let image = UIImage(data: data),
                 error == nil else {return}
            DispatchQueue.main.async {
                ImageCache.shared.save(image: image, forKey: urlString)
                if self.imageUrlString == urlString {
                    self.setImage(image: image, canAnimate: true)
                    completion()
                }
            }
        }
        currentTask = dataTask
        dataTask.resume()
        
    }
}
