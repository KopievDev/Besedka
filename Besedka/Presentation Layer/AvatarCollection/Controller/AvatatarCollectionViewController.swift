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
    let serviceAssembly: ServiceProtocol
    let network: NetworkServiceProtocol
    var imageUrls = [String]()
    weak var delegate: ChangeImage?
    
    // MARK: - Lifecycle
    init(serviceAssembly: ServiceProtocol) {
        self.serviceAssembly = serviceAssembly
        self.network = serviceAssembly.network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getUrls(with: getRandomCode())
    }
    
    // MARK: - Helpers
    private func setup() {
        view.addSubview(avatarView)
        self.avatarView.avatarCollection.dataSource = self
        self.avatarView.avatarCollection.delegate = self
        self.avatarView.searchImage.delegate = self
        self.avatarView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.avatarView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.avatarView.avatarCollection.keyboardDismissMode  = .interactive
    }
    
    private func getUrls(with code: String) {
        avatarView.indicator.startAnimating()
        network.getImagesUrls(with: code) {[weak self] urls in
            guard let `self` = self else {return}
            self.imageUrls = urls
            self.avatarView.indicator.stopAnimating()
            self.avatarView.avatarCollection.reloadData()
            if urls.count == 0 {self.showAlert()}
        }
    }
    
    func getTextFromTextfield() -> String {
        guard let text = self.avatarView.searchImage.text else {return "fails"}
        let code = text.split(separator: " ").reduce("") {$0 + "+" + $1}
        return code
    }
    
    func getRandomCode() -> String {
        enum UrlColor: String, CaseIterable {
            case blue, yellow, red, moscow, green, orange, gray, purple, developer, black, dark, city, space
        }
        guard let code = UrlColor.allCases.randomElement()?.rawValue else {return "fails"}
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
        self.avatarView.searchImage.text = ""
        self.getUrls(with: getRandomCode())
        self.avatarView.refreshControl.endRefreshing()
    }
        
}

// MARK: - Extension CollectionView DataSource
extension AvatatarCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.avatarView.cellId, for: indexPath)
        return configure(cell, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func configure(_ cell: UICollectionViewCell, at indexPath: IndexPath) -> AvatarCell {
        guard let `cell` = cell as? AvatarCell else {return AvatarCell()}
        cell.avatarImageView.image = UIImage(named: "placeholder")
        let url = self.imageUrls[indexPath.row]
        cell.imageURL = url
        cell.indicator.startAnimating()
        network.getImage(from: url) { image in
            if cell.imageURL == url {
                cell.avatarImageView.setImage(image: image, canAnimate: true)
                cell.indicator.stopAnimating()
            }
        }
        return cell
    }

}

// MARK: - Extension CollectionView Delegate
extension AvatatarCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = avatarView.avatarCollection.cellForItem(at: indexPath) as? AvatarCell,
              let image = cell.avatarImageView.image, image != UIImage(named: "placeholder") else {return}
        self.delegate?.selected(image)
    }
}

// MARK: - Extension TextFieldDelegate
extension AvatatarCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.avatarView.searchImage.text?.count ?? 0 > 1 {
            self.getUrls(with: getTextFromTextfield())
        }
        textField.resignFirstResponder()
        return true
    }
    
}
