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
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, _, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }
                
                if let unwrappedData = data, let downloadedImage = UIImage(data: unwrappedData) {
                    DispatchQueue.main.async {
                        ImageCache.shared.save(image: downloadedImage, forKey: urlString)
                        if self.imageUrlString == urlString {
                            self.setImage(image: downloadedImage, canAnimate: true)
                            completion()
                        }
                    }
                }
                
            }
            currentTask = dataTask
            dataTask.resume()
        }
        
    }
}
