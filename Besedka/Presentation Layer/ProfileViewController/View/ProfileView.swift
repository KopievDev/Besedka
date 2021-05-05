//
//  ProfileView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import UIKit

class ProfileView: UIView {
    // MARK: - Properties
    let radius: CGFloat
    let animator: AnimationProtocol
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
        textfield.accessibilityIdentifier = "NameTextfield"
        textfield.returnKeyType = .next
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
        textfield.accessibilityIdentifier = "CityTextfield"
        textfield.returnKeyType = .done
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
        textView.accessibilityIdentifier = "DescriptionTextView"
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
        self.radius = radius
        self.animator = animator
        super.init(frame: frame)
        createDesing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Design

    private func createDesing() {
        addSubview(avatarImageView)
        addSubview(shortName)
        addSubview(descriptionLabel)
        addSubview(nameLabel)
        addSubview(editButton)
        addSubview(closeButton)
        addSubview(titleLabel)
        
        addSubview(userNameTextfiel)
        addSubview(descriptionTextView)
        addSubview(cityTextfield)
        addSubview(saveGCDButton)
        addSubview(cancelButton)
        addSubview(activityIndicator)
        descriptionTextView.addSubview(placeholderLabel)
        createConstraints()
        setupColors()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func setupColors() {
        backgroundColor = Theme.current.backgroundColor
        closeButton.setTitleColor(Theme.current.labelColor, for: .normal)
        closeButton.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        editButton.backgroundColor = Theme.current.buttonBackground
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            avatarImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            
            shortName.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            shortName.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            shortName.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            descriptionLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: editButton.topAnchor, constant: -20),
            
            editButton.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: -30),
            editButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            editButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -25 ),
            editButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            editButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            userNameTextfiel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            userNameTextfiel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            userNameTextfiel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            userNameTextfiel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            descriptionTextView.topAnchor.constraint(equalTo: userNameTextfiel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            cityTextfield.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            cityTextfield.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            cityTextfield.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            cityTextfield.heightAnchor.constraint(equalTo: userNameTextfiel.heightAnchor),
            
            cancelButton.topAnchor.constraint(greaterThanOrEqualTo: cityTextfield.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: saveGCDButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: saveGCDButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            saveGCDButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 16),
            saveGCDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            saveGCDButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            saveGCDButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
            saveGCDButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            placeholderLabel.widthAnchor.constraint(equalTo: descriptionTextView.widthAnchor)
            
        ])
        
    }
    
    // MARK: - Helpers
    
    public func showEditButton(state: Bool = true) {
        saveGCDButton.isHidden = !state
        cancelButton.isHidden = !state
        editButton.isHidden = state
    }
    
    public func enableEditMode(state: Bool = true) {
        // Обнуляем значения
        if state {
            registerForKeyboardNotification()
            userNameTextfiel.becomeFirstResponder()
            clearData()
        }
        showEditButton(state: state)
        cityTextfield.isHidden = !state
        descriptionTextView.isHidden = !state
        userNameTextfiel.isHidden = !state
        placeholderLabel.isHidden = !state
        nameLabel.isHidden = state
        descriptionLabel.isHidden = state
    }
    
    public func disableButton( state: Bool = true) {
        saveGCDButton.isEnabled = !state
        saveGCDButton.backgroundColor = Theme.current.buttonDisable
        saveGCDButton.setTitleColor(Theme.current.subtleLabelColor, for: .normal)
        animator.removeShake(from: saveGCDButton)
        if !state {
            animator.addShake(to: saveGCDButton)
            saveGCDButton.backgroundColor = Theme.current.buttonBackground
            saveGCDButton.setTitleColor(Theme.current.secondaryLabelColor, for: .normal)
        }
    }
    
    public func clearData() {
        userNameTextfiel.text = ""
        cityTextfield.text = ""
        descriptionTextView.text = ""
        placeholderLabel.isHidden = false
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
        if bounds.origin.y == 0 && frame.height - cityTextfield.frame.maxY <= keyboardFrame.height {
            bounds.origin.y += keyboardFrame.height - (frame.height - cityTextfield.frame.maxY) + 16
        }
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            addGestureRecognizer(keyboardDismissTapGesture!)
        }
        
    }
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc private func keyboardWillHide() {
        if bounds.origin.y != 0 {
            bounds.origin.y = 0
            if keyboardDismissTapGesture != nil {
                removeGestureRecognizer(keyboardDismissTapGesture!)
                keyboardDismissTapGesture = nil
            }
        }
    }
    
    @objc private func handleTextInputChange() {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
}
