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
    
    func loadImageWithUrl(urlString: String) {
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        imageUrlString = urlString
        
        image = nil
        
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            image = cachedImage
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
                            self.image = downloadedImage
                        }
                    }
                }
                
            }
            currentTask = dataTask
            dataTask.resume()
        }
    }
}
