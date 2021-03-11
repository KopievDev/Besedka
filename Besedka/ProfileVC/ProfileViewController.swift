//
//  ProfileViewControllerTwo.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    lazy var radius = CGFloat()
    //UI
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = radius
        imageView.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(_:)))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.numberOfLines = 1
        label.text = "My Profile"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shortName : UILabel = {
        let label = UILabel()
        label.text = "NN"
        label.font = .systemFont(ofSize: 120)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.text = "Ivan Kopiev"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.contentMode = .topLeft
        label.text = "iOS Software Engineer \nMoscow, Russia"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    lazy var editButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: #selector(closeProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createDesing()
    }
    
    deinit {
        print("Deinit profileVC")
    }
        
    //MARK: - Helpers
    
    private func createDesing(){

        self.view.addSubview(avatarImageView)
        self.view.addSubview(shortName)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(editButton)
        self.view.addSubview(closeButton)
        self.view.addSubview(titleLabel)

        createConstraints()
        setupColors()
        setupDesign()
    }
    
    
    private func setupDesign(){
        
        //Get short name from name
        if let name = self.nameLabel.text{
            self.shortName.text = "\(name.split(separator: " ")[0].first ?? "n")\(name.split(separator: " ")[1].first ?? "n")".uppercased()
        }
        //Get saved image
        let defaults = UserDefaults.standard
        guard let image = defaults.data(forKey: "saveImg") else {return}
        self.avatarImageView.image = UIImage(data: image, scale: 0.5)
        self.shortName.isHidden = true
        self.avatarImageView.layer.cornerRadius = radius

    }
    private func setupColors(){
        self.view.backgroundColor = Theme.current.backgroundColor
        self.closeButton.setTitleColor(Theme.current.labelColor, for: .normal)
        self.closeButton.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        self.editButton.backgroundColor = Theme.current.buttonBackground
    }
    
    private func createConstraints(){
        
        NSLayoutConstraint.activate([
            self.avatarImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            self.avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.avatarImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.avatarImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            
            self.shortName.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.shortName.centerYAnchor.constraint(equalTo: self.avatarImageView.centerYAnchor),
            self.shortName.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 32),
            self.nameLabel.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 25),

            self.descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),

            self.editButton.topAnchor.constraint(greaterThanOrEqualTo: self.descriptionLabel.bottomAnchor, constant: -30),
            self.editButton.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            self.editButton.heightAnchor.constraint(equalToConstant: 60),
            self.editButton.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.editButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30 ),
            
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.closeButton.heightAnchor.constraint(equalToConstant: 30),
            self.closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)

            
        ])
        
    }
    //MARK: - Selectors
    @objc func selectPhoto(_ sender: UITapGestureRecognizer){
        
        let alertSheet = UIAlertController(title: nil,
                                           message: nil,
                                           preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Выбрать фото", style: .default, handler: { _ in
            self.chooseImagePicker(source: .photoLibrary)
            
        })
        
        let camera = UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in
            self.chooseImagePicker(source: .camera)
        })
        let cancel = UIAlertAction(title: "Отмена", style: .cancel )
        
        alertSheet.addAction(photo)
        alertSheet.addAction(camera)
        alertSheet.addAction(cancel)
        present(alertSheet, animated: true)
        
    }
    
    @objc private func editProfile(){
        
        // +++++ Лишний код - начало +++++
        let alertController = UIAlertController(title: "Настойка профиля", message: "Введите свои данные:", preferredStyle: .alert)
        let apply = UIAlertAction(title: "Применить", style: .default, handler: {_ in
            let text = alertController.textFields?[0].text ?? ""
            if text.split(separator: " ").count >= 2 {
                
                self.nameLabel.text = text
                self.shortName.text = "\(text.split(separator: " ")[0].first ?? "N")\(text.split(separator: " ")[1].first ?? "N")".uppercased()
            }else {
                self.nameLabel.text = "No Name"
                self.shortName.text =  "\(self.nameLabel.text?.split(separator: " ")[0].first ?? "N")\(self.nameLabel.text?.split(separator: " ")[1].first ?? "N")".uppercased()
            }
            let descText = alertController.textFields?[1].text ?? ""
            let geoText = alertController.textFields?[2].text ?? ""

            if descText.count >= 1 {
                self.descriptionLabel.text = "\(descText)\n\(geoText)"
            }else{
                self.descriptionLabel.text = "Opps..."
            }
        })
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(apply)
        alertController.addAction(cancel)
        alertController.addTextField{ (textField) in
            textField.placeholder = "Введите имя и фамилию"
        }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Введите информацию о себе"
        }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Страна, город?"
        }
        
        present(alertController, animated: true)
        // +++++ Лишний код - конец +++++
    }
    
    @objc private func closeProfile(){
        dismiss(animated: true)
    }
}

//MARK: - Extension UIImagePicker - work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.avatarImageView.image = info[.editedImage] as? UIImage
        let imgData = (self.avatarImageView.image ?? UIImage()).jpegData(compressionQuality: 0.3)
        UserDefaults.standard.set(imgData, forKey: "saveImg")
        self.shortName.isHidden = true
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.avatarImageView.image = nil
        self.shortName.isHidden = false
        dismiss(animated: true)
        UserDefaults.standard.set(nil, forKey: "saveImg")

    }
}

    


