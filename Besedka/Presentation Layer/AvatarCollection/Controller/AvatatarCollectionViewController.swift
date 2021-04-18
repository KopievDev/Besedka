//
//  AvatatarCollectionViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

class AvatatarCollectionViewController: UIViewController {
    
    // MARK: - Properties
    private let cellId = "cellAvatar"
    private lazy var avatarCollection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = (view.frame.width - 40) / 3
        layout.itemSize = CGSize(width: width, height: width)
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.register(AvatarCell.self, forCellWithReuseIdentifier: cellId)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
   
    let serviceAssembly: ServiceAssembly = ServiceAssembly()
    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = Theme.current.bubbleFromMe
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    var imageUrls = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDesign()
        getUrls()
    }
    
    // MARK: - Helpers
    private func createDesign() {
        view.backgroundColor = Theme.current.backgroundColor
        view.addSubview(avatarCollection)
        view.addSubview(indicator)
        avatarCollection.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 30),
            indicator.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func getUrls() {
        let network = serviceAssembly.network
        indicator.startAnimating()
        network.getImagesUrls { (urls) in
            self.imageUrls = urls
            self.indicator.stopAnimating()
            self.avatarCollection.reloadData()
        }
    }
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "Изображение сохранено", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) {[weak self] _ in
            self?.close()
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Selectors
    
    @objc func refresh() {
        self.getUrls()
        self.refreshControl.endRefreshing()
    }
        
}

// MARK: - Extension

extension AvatatarCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? AvatarCell else { return UICollectionViewCell()}
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
       guard let cell = avatarCollection.cellForItem(at: indexPath) as? AvatarCell else {return}
        let filesaver = serviceAssembly.fileManager
        filesaver.saveImageToFile(cell.avatarImageView.image, byName: "Avatar.png") {[weak self] in
            print("photo is saved")
            self?.showAlert()
            
        }
    }
}
