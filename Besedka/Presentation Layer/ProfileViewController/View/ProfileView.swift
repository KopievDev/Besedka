//
//  ProfileView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import UIKit

class ProfileView: UIView {
    // MARK: - Properties
    lazy var radius = CGFloat()
    var animator: AnimationProtocol?
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    // MARK: - UI
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = radius
        imageView.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.setImage(UIImage(named: "closeTap"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textfield.leftViewMode = .always
        return textfield
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.addCornerRadius(10)
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
    
    // MARK: - Lifecycle
    init(frame: CGRect, radius: CGFloat, animator: AnimationProtocol) {
        super.init(frame: frame)
        self.radius = radius
        self.animator = animator
        createDesing()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Design

    private func createDesing() {
        self.addSubview(avatarImageView)
        self.addSubview(shortName)
        self.addSubview(descriptionLabel)
        self.addSubview(nameLabel)
        self.addSubview(editButton)
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        
        self.addSubview(userNameTextfiel)
        self.addSubview(descriptionTextView)
        self.addSubview(cityTextfield)
        self.addSubview(saveGCDButton)
        self.addSubview(cancelButton)
        self.addSubview(activityIndicator)
        self.descriptionTextView.addSubview(placeholderLabel)
        createConstraints()
        setupColors()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func setupColors() {
        self.backgroundColor = Theme.current.backgroundColor
        self.closeButton.setTitleColor(Theme.current.labelColor, for: .normal)
        self.closeButton.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        self.editButton.backgroundColor = Theme.current.buttonBackground
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            self.avatarImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            self.avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.avatarImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.avatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            
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
            self.editButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -25 ),
            self.editButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            self.editButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            self.closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            self.closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.closeButton.heightAnchor.constraint(equalToConstant: 35),
            self.closeButton.widthAnchor.constraint(equalToConstant: 35),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
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
            self.saveGCDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.saveGCDButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            self.saveGCDButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
            self.saveGCDButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.placeholderLabel.topAnchor.constraint(equalTo: self.descriptionTextView.topAnchor, constant: 8),
            self.placeholderLabel.leadingAnchor.constraint(equalTo: self.descriptionTextView.leadingAnchor, constant: 5),
            self.placeholderLabel.widthAnchor.constraint(equalTo: descriptionTextView.widthAnchor)
            
        ])
        
    }
    
    // MARK: - Helpers
    
    public func showEditButton(state: Bool = true) {
        self.saveGCDButton.isHidden = !state
        self.cancelButton.isHidden = !state
        self.editButton.isHidden = state
    }
    
    public func enableEditMode(state: Bool = true) {
        // Обнуляем значения
        if state {
            self.registerForKeyboardNotification()
            self.userNameTextfiel.becomeFirstResponder()
            self.clearData()
        }
        showEditButton(state: state)
        self.cityTextfield.isHidden = !state
        self.descriptionTextView.isHidden = !state
        self.userNameTextfiel.isHidden = !state
        self.placeholderLabel.isHidden = !state
        self.nameLabel.isHidden = state
        self.descriptionLabel.isHidden = state
    }
    
    public func disableButton( state: Bool = true) {
        self.saveGCDButton.isEnabled = !state
        self.saveGCDButton.backgroundColor = Theme.current.buttonDisable
        self.saveGCDButton.setTitleColor(Theme.current.subtleLabelColor, for: .normal)
        self.animator?.removeShake(from: saveGCDButton)
        if !state {
            self.animator?.addShake(to: saveGCDButton)
            self.saveGCDButton.backgroundColor = Theme.current.buttonBackground
            self.saveGCDButton.setTitleColor(Theme.current.secondaryLabelColor, for: .normal)
        }
    }
    
    public func clearData() {
        self.userNameTextfiel.text = ""
        self.cityTextfield.text = ""
        self.descriptionTextView.text = ""
    }
    public func dataChecking() {
        var formIsValid: Bool {
            return userNameTextfiel.isEmpty()
                && cityTextfield.isEmpty()
                && descriptionTextView.isEmpty()
        }
        disableButton(state: formIsValid)
    }
    
    //  Обработка появления клавиатуры
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if self.bounds.origin.y == 0 && self.frame.height - cityTextfield.frame.maxY <= keyboardFrame.height {
            self.bounds.origin.y += keyboardFrame.height - (self.frame.height - cityTextfield.frame.maxY) + 16
        }
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.addGestureRecognizer(keyboardDismissTapGesture!)
        }
        
    }
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc private func keyboardWillHide() {
        if self.bounds.origin.y != 0 {
            self.bounds.origin.y = 0
            if keyboardDismissTapGesture != nil {
                self.removeGestureRecognizer(keyboardDismissTapGesture!)
                keyboardDismissTapGesture = nil
            }
        }
    }
    
    @objc private func handleTextInputChange() {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
}
