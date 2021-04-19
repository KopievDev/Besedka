//
//  Profile.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properies
    lazy var radius = CGFloat()
    lazy var serviceAssembly = ServiceAssembly()
    var user = UserProfile()
    var profile = ProfileView()
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profile = ProfileView(frame: self.view.frame, radius: radius)
        view.addSubview(profile)
        setupDesign()
        addTarget()
    }
    
    // MARK: - Helpers
    func addTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(_:)))
        profile.avatarImageView.addGestureRecognizer(tapGesture)
        profile.editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        profile.closeButton.addTarget(self, action: #selector(closeProfile), for: .touchUpInside)
        profile.saveGCDButton.addTarget(self, action: #selector(saveGCD), for: .touchUpInside)
        profile.cancelButton.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
        profile.userNameTextfiel.delegate = self
        profile.cityTextfield.delegate = self
        profile.descriptionTextView.delegate = self
    }
    
    private func setupDesign() {
        addTarget()
        let fileOpener = serviceAssembly.fileManager
        fileOpener.getImageFromFile(name: "Avatar.png",
                                    runQueue: .global(qos: .utility),
                                    completionQueue: .main) { [weak self] (image) in
            guard let self = self else {return}
            guard let  image = image else {return}
            self.profile.avatarImageView.image = image
            self.profile.shortName.isHidden = true
            
        }
        fileOpener.getUser {[weak self] (user) in
            guard let newUser = user else {return}
            guard let self = self else {return}
            self.user = newUser // резерв для отмены
            // Get user data
            let descText = newUser.aboutMe ?? ""
            let geoText = newUser.city ?? ""
            self.profile.descriptionLabel.text = "\(descText)\n\(geoText)"
            self.profile.nameLabel.text = newUser.name ?? ""
            // Get short name from name
            let text = newUser.name ?? ""
            if text.split(separator: " ").count >= 2 {
                self.profile.shortName.text = "\(text.split(separator: " ")[0].first ?? "n")\(text.split(separator: " ")[1].first ?? "n")".uppercased()
            } else {
                self.profile.shortName.text = text.first?.uppercased()
            }
        }
    }
    
    private func returnModifiedData() -> UserProfile {
        var newUser = self.user
        if profile.userNameTextfiel.text != "" {
            newUser.name = profile.userNameTextfiel.text
        }
        if profile.descriptionTextView.text != "" {
            newUser.aboutMe = profile.descriptionTextView.text
        }
        if profile.cityTextfield.text != "" {
            newUser.city = profile.cityTextfield.text
        }
        return newUser
    }
    
    private func showAlert(state: Bool = true) {
        let alertView = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak self]  _ in
            guard let self = self else {return}
            self.profile.enableEditMode(state: false)
        })
        alertView.addAction(doneAction)
        let errorAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let repetAction = UIAlertAction(title: "Повторить", style: .destructive) {[weak self] _ in
            guard let self = self else {return}
            self.saveGCD()
        }
        let doneActionError = UIAlertAction(title: "Ok", style: .default, handler: {[weak self]  _ in
            guard let self = self else {return}
            self.profile.enableEditMode(state: false)
        })
        errorAlert.addAction(doneActionError)
        errorAlert.addAction(repetAction)
        if state {
            present(alertView, animated: true)
        } else {
            present(errorAlert, animated: true)
            
        }
    }
    
    // MARK: - Selectors
    @objc func selectPhoto(_ sender: UITapGestureRecognizer) {
        
        let alertSheet = UIAlertController(title: nil,
                                           message: nil,
                                           preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Выбрать фото", style: .default, handler: { _ in
            self.chooseImagePicker(source: .photoLibrary)
        })
        let camera = UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in
            self.chooseImagePicker(source: .camera)
        })
        let online = UIAlertAction(title: "Загрузить фото", style: .default, handler: { _ in
            print("debyuug")
            let avatarVC = AvatatarCollectionViewController()
            avatarVC.delegate = self
            avatarVC.modalPresentationStyle = .fullScreen
            self.present(avatarVC, animated: true)

//            self.present(avatarVC, animated: true) {
//                print("present")
//            }
        })
        let cancel = UIAlertAction(title: "Отмена", style: .cancel )
        alertSheet.addAction(photo)
        alertSheet.addAction(camera)
        alertSheet.addAction(online)
        alertSheet.addAction(cancel)
        present(alertSheet, animated: true)
        
    }
    
    @objc private func cancelEditing() {
        profile.enableEditMode(state: false)
        let oldSetting = serviceAssembly.fileManager
        oldSetting.saveUser(self.user, completion: {_ in })
        self.setupDesign()
        oldSetting.getImageFromFile(name: "Avatar.png", runQueue: .global(), completionQueue: .main) {[weak self] (image) in
            guard let `self` = self else {return}
            guard let img = image else {return}
            self.profile.avatarImageView.setImage(image: img, canAnimate: true)
        }
    }
    
    @objc private func editProfile() {
        profile.enableEditMode(state: true)
    }
    
    @objc private func closeProfile() {
        dismiss(animated: true)
    }
    
    @objc private func saveGCD() {
        
        let saver = serviceAssembly.fileManager
        let user = returnModifiedData()
        
        profile.activityIndicator.startAnimating()
        profile.activityIndicator.isHidden = false
        profile.disableButton()
        // Если изменено только фото
        if profile.userNameTextfiel.isHidden {
            saver.saveImageToFile(profile.avatarImageView.image, byName: "Avatar.png") {[weak self] in
                guard let self = self else { return }
                self.profile.activityIndicator.stopAnimating()
                self.showAlert()
            }
        } else {
            // Если изменены фото и данные
            saver.saveUser(user) {[weak self] error in
                guard let self = self else {return}
                self.setupDesign()
                self.profile.activityIndicator.stopAnimating()
                if error != nil {self.showAlert(state: false); return}
                self.showAlert(state: true)
            }
            saver.saveImageToFile(profile.avatarImageView.image, byName: "Avatar.png", completion: {
            })
        }
    }
    
}

extension ProfileViewController: ChangeImage {
    func selected(_ image: UIImage) {
        setAvatar(image)
    }
}
