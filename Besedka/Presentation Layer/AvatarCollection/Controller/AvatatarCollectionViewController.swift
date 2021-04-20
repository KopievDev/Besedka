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
        self.avatarView.searchImage.delegate = self
        self.avatarView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.avatarView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func getUrls() {
        let network = serviceAssembly.network
            avatarView.indicator.startAnimating()
        network.getRandomImage { (urls) in
            self.imageUrls = urls
            self.avatarView.indicator.stopAnimating()
            self.avatarView.avatarCollection.reloadData()
        }
    }
    
    func getTextFromTextfield() -> String {
        guard let text = self.avatarView.searchImage.text else {return "fail"}
        let code = text.split(separator: " ").reduce("") {$0 + "+" + $1}
        return code
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Упс....", message: "По данному запросу ничего не найдено...", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
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

extension AvatatarCollectionViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let network = serviceAssembly.network
        if self.avatarView.searchImage.text?.count ?? 0 > 1 {
            avatarView.indicator.startAnimating()
            network.getImagesUrls(with: getTextFromTextfield()) { urls in
                self.imageUrls = urls
                self.avatarView.indicator.stopAnimating()
                self.avatarView.avatarCollection.reloadData()
                if urls.count == 0 {
                    self.showAlert()
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}
