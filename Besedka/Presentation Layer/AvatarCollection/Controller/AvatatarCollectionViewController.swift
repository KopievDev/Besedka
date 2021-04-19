//
//  AvatatarCollectionViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol ChangeImage: class {
    func selected(_ image: UIImage)
}

class AvatatarCollectionViewController: UIViewController {
    
    // MARK: - Properties
    lazy var avatarView = AvatarView(frame: self.view.frame)
    let serviceAssembly: ServiceAssembly = ServiceAssembly()
    var imageUrls = [String]()
    weak var delegate: ChangeImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
        getUrls()
    }
    
    // MARK: - Helpers
    private func setupSettings() {
        view.addSubview(avatarView)
        self.avatarView.avatarCollection.dataSource = self
        self.avatarView.avatarCollection.delegate = self
        self.avatarView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.avatarView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func getUrls() {
        let network = serviceAssembly.network
            avatarView.indicator.startAnimating()
        network.getImagesUrls { (urls) in
            self.imageUrls = urls
            self.avatarView.indicator.stopAnimating()
            self.avatarView.avatarCollection.reloadData()
        }
    }
    
    // MARK: - Selectors
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc func refresh() {
        self.getUrls()
        self.avatarView.refreshControl.endRefreshing()
    }
        
}

// MARK: - Extension
extension AvatatarCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.avatarView.cellId, for: indexPath) as? AvatarCell else { return UICollectionViewCell()}
        cell.imageUrl = imageUrls[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

}

extension AvatatarCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let cell = avatarView.avatarCollection.cellForItem(at: indexPath) as? AvatarCell else {return}
        guard let image = cell.avatarImageView.image, image != UIImage(named: "placeholder") else {return}
        self.delegate?.selected(image)
    }
}
