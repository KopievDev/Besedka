//
//  ProfileViewControllerTwo.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properties
    lazy var radius = CGFloat()
    var user = UserProfileModel()
    // UI
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.numberOfLines = 1
        label.text = "My Profile"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shortName: UILabel = {
        let label = UILabel()
        label.text = "NN"
        label.font = .systemFont(ofSize: 120)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.text = "Ivan Kopiev"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.contentMode = .topLeft
        label.text = "iOS Software Engineer \nMoscow, Russia"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var editButton: UIButton = {
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
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: #selector(closeProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - HOMEWORK #5
    lazy var userNameTextfiel: UITextField = {
       let textfield = UITextField()
        textfield.isHidden = true
        textfield.attributedPlaceholder = NSAttributedString(string: "ФИО",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        textfield.font = .systemFont(ofSize: 16)
        textfield.clearButtonMode = .whileEditing
        textfield.addBorderLine(color: Theme.current.secondaryLabelColor)
        textfield.addCornerRadius(8)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textfield.leftViewMode = .always
        return textfield
    }()
    lazy var cityTextfield: UITextField = {
       let textfield = UITextField()
        textfield.isHidden = true
        textfield.font = .systemFont(ofSize: 16)
        textfield.attributedPlaceholder = NSAttributedString(string: "Город, Страна",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        textfield.addBorderLine(color: Theme.current.secondaryLabelColor)
        textfield.addCornerRadius(8)
        textfield.clearButtonMode = .whileEditing
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textfield.leftViewMode = .always
        return textfield
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.addCornerRadius(10)
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        textView.addBorderLine(color: Theme.current.secondaryLabelColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    lazy var saveGCDButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(saveGCD), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.isHidden = true
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    lazy var placeholderLabel: SecondaryLabel = {
        let label = SecondaryLabel()
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        label.text = "О себе: "
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.color = Theme.current.labelColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    var keyboardDismissTapGesture: UIGestureRecognizer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createDesing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Helpers
    private func createDesing() {
        self.view.addSubview(avatarImageView)
        self.view.addSubview(shortName)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(editButton)
        self.view.addSubview(closeButton)
        self.view.addSubview(titleLabel)
    
        self.view.addSubview(userNameTextfiel)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(cityTextfield)
        self.view.addSubview(saveGCDButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(activityIndicator)
        self.descriptionTextView.addSubview(placeholderLabel)
        createConstraints()
        setupColors()
        setupDesign()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func setupDesign() {
        let fileOpener = FileManagerGCD()
        fileOpener.getImageFromFile(name: "Avatar.png",
                                    runQueue: .global(qos: .utility),
                                    completionQueue: .main) { [weak self] (image) in
            guard let self = self else {return}
            guard let  image = image else {return}
            self.avatarImageView.image = image
            self.shortName.isHidden = true

        }
        fileOpener.getUser {[weak self] (user) in
            guard let newUser = user else {return}
            guard let self = self else {return}
            print(newUser)
            self.user = newUser // резерв для отмены
            // Get user data
            let descText = newUser.aboutMe ?? ""
            let geoText = newUser.city ?? ""
            self.descriptionLabel.text = "\(descText)\n\(geoText)"
            self.nameLabel.text = newUser.name ?? ""
            // Get short name from name
            let text = newUser.name ?? ""
            if text.split(separator: " ").count >= 2 {
            self.shortName.text = "\(text.split(separator: " ")[0].first ?? "n")\(text.split(separator: " ")[1].first ?? "n")".uppercased()
            } else {
                self.shortName.text = text.first?.uppercased()
            }
        }
    }
    
    private func setupColors() {
        self.view.backgroundColor = Theme.current.backgroundColor
        self.closeButton.setTitleColor(Theme.current.labelColor, for: .normal)
        self.closeButton.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        self.editButton.backgroundColor = Theme.current.buttonBackground
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            self.avatarImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            self.avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.avatarImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.avatarImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            
            self.shortName.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.shortName.centerYAnchor.constraint(equalTo: self.avatarImageView.centerYAnchor),
            self.shortName.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 16),
            self.nameLabel.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 25),

            self.descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            self.descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: editButton.topAnchor, constant: -20),

            self.editButton.topAnchor.constraint(greaterThanOrEqualTo: self.descriptionLabel.bottomAnchor, constant: -30),
            self.editButton.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
            self.editButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25 ),
            self.editButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            self.editButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.closeButton.heightAnchor.constraint(equalToConstant: 30),
            self.closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
           
            self.userNameTextfiel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            self.userNameTextfiel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.userNameTextfiel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            self.userNameTextfiel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
           
            self.descriptionTextView.topAnchor.constraint(equalTo: userNameTextfiel.bottomAnchor, constant: 16),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            self.descriptionTextView.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor),
            self.descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            self.descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
           
            self.cityTextfield.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            self.cityTextfield.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            self.cityTextfield.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.cityTextfield.heightAnchor.constraint(equalTo: userNameTextfiel.heightAnchor),
           
            self.cancelButton.topAnchor.constraint(greaterThanOrEqualTo: cityTextfield.bottomAnchor, constant: 16),
            self.cancelButton.leadingAnchor.constraint(equalTo: saveGCDButton.leadingAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: saveGCDButton.trailingAnchor),
            self.cancelButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            self.cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            self.saveGCDButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 16),
            self.saveGCDButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            self.saveGCDButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            self.saveGCDButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
            self.saveGCDButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.placeholderLabel.topAnchor.constraint(equalTo: self.descriptionTextView.topAnchor, constant: 8),
            self.placeholderLabel.leadingAnchor.constraint(equalTo: self.descriptionTextView.leadingAnchor, constant: 5),
            self.placeholderLabel.widthAnchor.constraint(equalTo: descriptionTextView.widthAnchor)
            
        ])
        
    }
    //  Обработка появления клавиатуры
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if view.bounds.origin.y == 0 && view.frame.height - cityTextfield.frame.maxY <= keyboardFrame.height {
            self.view.bounds.origin.y += keyboardFrame.height - (view.frame.height - cityTextfield.frame.maxY) + 16
        }
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
        
    }
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillHide() {
        if view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
            if keyboardDismissTapGesture != nil {
                self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
                keyboardDismissTapGesture = nil
            }
        }
    }
    
    public func showEditButton(state: Bool = true) {
        self.saveGCDButton.isHidden = !state
        self.cancelButton.isHidden = !state
        self.editButton.isHidden = state
    }
    
    private func enableEditMode(state: Bool = true) {
        // Обнуляем значения
        if state {
            self.registerForKeyboardNotification()
            self.userNameTextfiel.becomeFirstResponder()
            self.userNameTextfiel.text = ""
            self.cityTextfield.text = ""
            self.descriptionTextView.text = ""
        }
        showEditButton(state: state)
        self.cityTextfield.isHidden = !state
        self.descriptionTextView.isHidden = !state
        self.userNameTextfiel.isHidden = !state
        self.placeholderLabel.isHidden = !state
        self.nameLabel.isHidden = state
        self.descriptionLabel.isHidden = state
    }
    
    public func dataChecking() {
        var formIsValid: Bool {
            return self.userNameTextfiel.isEmpty()
                && self.cityTextfield.isEmpty()
                && self.descriptionTextView.isEmpty()
        }
        disableButton(state: formIsValid)
    }
    
    private func showAlert(state: Bool = true) {
        let alertView = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak self]  _ in
            guard let self = self else {return}
            self.enableEditMode(state: false)
        })
        alertView.addAction(doneAction)
        let errorAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let repetAction = UIAlertAction(title: "Повторить", style: .destructive) {[weak self] _ in
            guard let self = self else {return}
                self.saveGCD()
            }
        let doneActionError = UIAlertAction(title: "Ok", style: .default, handler: {[weak self]  _ in
            guard let self = self else {return}
            self.enableEditMode(state: false)
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
        let cancel = UIAlertAction(title: "Отмена", style: .cancel )
        alertSheet.addAction(photo)
        alertSheet.addAction(camera)
        alertSheet.addAction(cancel)
        present(alertSheet, animated: true)
        
    }
    
    @objc private func handleTextInputChange() {
        self.placeholderLabel.isHidden = !self.descriptionTextView.text.isEmpty
    }
    
    @objc private func cancelEditing() {
        enableEditMode(state: false)
        let oldSetting = FileManagerGCD()
        oldSetting.saveUser(self.user, completion: {_ in })
    }
    
    @objc private func editProfile() {
        enableEditMode(state: true)
    }
    public func disableButton( state: Bool = true) {
        self.saveGCDButton.isEnabled = !state
        self.saveGCDButton.backgroundColor = Theme.current.buttonDisable
        self.saveGCDButton.setTitleColor(Theme.current.subtleLabelColor, for: .normal)
        if !state {
            self.saveGCDButton.backgroundColor = Theme.current.buttonBackground
            self.saveGCDButton.setTitleColor(Theme.current.secondaryLabelColor, for: .normal)
        }
    }
    
    // MARK: - Save GCD selector
    @objc private func saveGCD() {
        
        let saver = FileManagerGCD()
        let user = returnModifiedData()
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.disableButton()
        // Если изменено только фото
        if userNameTextfiel.isHidden {
            saver.saveImageToFile(self.avatarImageView.image, byName: "Avatar.png") {[weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.showAlert()
            }
        } else {
            // Если изменены фото и данные
            saver.saveUser(user) {[weak self] error in
                guard let self = self else {return}
                self.setupDesign()
                self.activityIndicator.stopAnimating()
                if error != nil {self.showAlert(state: false); return}
                self.showAlert(state: true)
            }
            saver.saveImageToFile(self.avatarImageView.image, byName: "Avatar.png", completion: {
            })
        }
    }
    
    private func returnModifiedData() -> UserProfileModel {
        var newUser = self.user
        if userNameTextfiel.text != "" {
            newUser.name = userNameTextfiel.text
        }
        if descriptionTextView.text != "" {
            newUser.aboutMe = descriptionTextView.text
        }
        if cityTextfield.text != "" {
            newUser.city = cityTextfield.text
        }
        return newUser
    }
    
    @objc private func closeProfile() {
        dismiss(animated: true)
    }
}
