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
    
    var user = UserProfileModel()
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
    
    //MARK: - HOMEWORK #5
    
    let userNameTextfiel: UITextField = {
       let textfield = UITextField()
        textfield.isHidden = true
        textfield.attributedPlaceholder = NSAttributedString(string: "ФИО",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        textfield.font = .systemFont(ofSize: 16)
        textfield.textAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.addBorderLine(color: Theme.current.secondaryLabelColor)
        textfield.addCornerRadius(8)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let cityTextfield: UITextField = {
       let textfield = UITextField()
        textfield.isHidden = true
        textfield.font = .systemFont(ofSize: 16)
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: "Город, Страна",
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryLabelColor])
        textfield.addBorderLine(color: Theme.current.secondaryLabelColor)
        textfield.addCornerRadius(8)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    

    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.addCornerRadius(10)
        textView.font = .systemFont(ofSize: 16)
        textView.addBorderLine(color: Theme.current.secondaryLabelColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var saveGcdButton : UIButton = {
        let button = UIButton()

        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(saveGCD), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
      
        button.setTitle("Save GCD", for: .normal)
       
        button.isHidden = true
       
        return button
    }()
    lazy var saveOperationButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save Operations", for: .normal)
        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
      
       
        button.isHidden = true
       
        return button
    }()
    
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = Theme.current.buttonBackground
        button.layer.cornerRadius = 15
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
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
    
    var clickEdit: Bool = true
    var constraintTextfieldLest = NSLayoutConstraint()
    
    //MARK: - Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user.initFromFile()
        createDesing()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        print(user)
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
        self.view.addSubview(userNameTextfiel)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(cityTextfield)
        self.view.addSubview(saveGcdButton)
        self.view.addSubview(saveOperationButton)
        self.view.addSubview(cancelButton)
        self.descriptionTextView.addSubview(placeholderLabel)
        createConstraints()
        setupColors()
        setupDesign()
        
    }
    
    
    private func setupDesign(){
        
        let descText = user.aboutMe ?? ""
        let geoText = user.city ?? ""
        self.descriptionLabel.text = "\(descText)\n\(geoText)"
        self.nameLabel.text = user.name ?? ""



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
//            self.editButton.heightAnchor.constraint(equalToConstant: 60),
//            self.editButton.widthAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),
            self.editButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25 ),
            self.editButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            self.editButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),


            
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.closeButton.heightAnchor.constraint(equalToConstant: 30),
            self.closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            //HOMEWORK 5 Edit mode
            
            //new
            self.userNameTextfiel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            self.userNameTextfiel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.userNameTextfiel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            self.descriptionTextView.topAnchor.constraint(equalTo: userNameTextfiel.bottomAnchor, constant: 16),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            self.descriptionTextView.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor),
            self.descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            self.descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
//                        self.descriptionTextView.heightAnchor.constraint(equalToConstant: 40),

            
            self.cityTextfield.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            self.cityTextfield.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            self.cityTextfield.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            
            
            self.cancelButton.topAnchor.constraint(greaterThanOrEqualTo: cityTextfield.bottomAnchor, constant: 16),
            self.cancelButton.leadingAnchor.constraint(equalTo: saveGcdButton.leadingAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: saveOperationButton.trailingAnchor),
//            self.cancelButton.heightAnchor.constraint(equalToConstant: 60),

            self.cancelButton.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            self.cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            
            self.saveGcdButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 16),
            self.saveGcdButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            self.saveGcdButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
            self.saveGcdButton.trailingAnchor.constraint(equalTo: saveOperationButton.leadingAnchor, constant: -16),
            self.saveGcdButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            self.saveGcdButton.widthAnchor.constraint(equalTo: saveOperationButton.widthAnchor),
            
            self.saveOperationButton.topAnchor.constraint(equalTo: saveGcdButton.topAnchor),
            self.saveOperationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            self.saveOperationButton.bottomAnchor.constraint(equalTo: saveGcdButton.bottomAnchor),
            self.saveOperationButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),

            
            
//            self.userNameTextfiel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
////            self.userNameTextfiel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -self.view.frame.width),
//            self.userNameTextfiel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
//            self.userNameTextfiel.heightAnchor.constraint(equalToConstant: 30),

            
//            self.descriptionTextView.topAnchor.constraint(equalTo: userNameTextfiel.bottomAnchor, constant: 16),
//            self.descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
//            self.descriptionTextView.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor),
//            self.descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
//
//            self.cityTextfield.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
//            self.cityTextfield.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            self.cityTextfield.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
//            self.cityTextfield.heightAnchor.constraint(equalToConstant: 30),
        
//            self.cancelButton.topAnchor.constraint(greaterThanOrEqualTo: cityTextfield.bottomAnchor, constant: 16),
//            self.cancelButton.leadingAnchor.constraint(equalTo: saveGcdButton.leadingAnchor),
//            self.cancelButton.trailingAnchor.constraint(equalTo: saveOperationButton.trailingAnchor),
////            self.cancelButton.heightAnchor.constraint(gre
//            self.cancelButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/12),

//            self.cancelButton.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -16),
//
//            self.saveGcdButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
//            self.saveGcdButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
//            self.saveGcdButton.trailingAnchor.constraint(equalTo: saveOperationButton.leadingAnchor, constant: -16),
////            self.saveGcdButton.heightAnchor.constraint(equalToConstant: 60),
//            self.saveGcdButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/12),
//
//            self.saveGcdButton.widthAnchor.constraint(equalTo: saveOperationButton.widthAnchor),
//
//
//
//            self.saveOperationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
//            self.saveOperationButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
////            self.saveOperationButton.heightAnchor.constraint(equalToConstant: 60),
//            self.saveOperationButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/12),

          
     
            self.placeholderLabel.topAnchor.constraint(equalTo: self.descriptionTextView.topAnchor, constant: 8),
            self.placeholderLabel.leadingAnchor.constraint(equalTo: self.descriptionTextView.leadingAnchor, constant: 5),
            self.placeholderLabel.widthAnchor.constraint(equalTo: descriptionTextView.widthAnchor)


            
        ])
        
//        constraintTextfieldLest = userNameTextfiel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -self.view.frame.width)
//
//        constraintTextfieldLest.isActive = true
    }
    //  Обработка появления клавиатуры
    private func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification,  object: nil)
        
    }
    @objc private func keyboardWillShow(_ notification: Notification){
        
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if view.bounds.origin.y == 0 && view.frame.height - cityTextfield.frame.maxY <= keyboardFrame.height {
            self.view.bounds.origin.y += keyboardFrame.height - (view.frame.height - cityTextfield.frame.maxY) + 16
        }
    }
    
    @objc private func keyboardWillHide(){
        if view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
        }
        
        
    }
    
    
    
    private func showEditButton(state: Bool = true){
        self.saveOperationButton.isHidden = !state
        self.saveGcdButton.isHidden = !state
        self.cancelButton.isHidden = !state
        self.editButton.isHidden = state
      
    }
    
    private func enableEditMode(state: Bool = true){
        self.registerForKeyboardNotification()
        //animation textfield
//        UIView.animate(withDuration: 0.5) {
//            self.constraintTextfieldLest.constant = 30
//            self.view.layoutIfNeeded()
//        }
//        UIView.animate(withDuration: 0.5) {
//            self.constraintTextfieldLest.constant = 30
//            self.view.layoutIfNeeded()
//        } completion: { (state) in
//            if state{
//                UIView.animate(withDuration: 0.2) {
//                    self.constraintTextfieldLest.constant = 0
//                    self.view.layoutIfNeeded()
//                }
//            }
//        }

        
        
        self.userNameTextfiel.becomeFirstResponder()

        //Обнуляем значения
        if state{
            self.userNameTextfiel.text = ""
            self.cityTextfield.text = ""
            self.descriptionTextView.text = ""
        }
        
        showEditButton(state: state)

        self.cityTextfield.isHidden = !state
        self.descriptionTextView.isHidden = !state
        self.userNameTextfiel.isHidden = !state
        self.saveOperationButton.isHidden = !state
        self.placeholderLabel.isHidden = !state

        
        self.nameLabel.isHidden = state
        self.descriptionLabel.isHidden = state
        
//        if !state{
//            self.nameLabel.text = userNameTextfiel.text
//            let descText = descriptionTextView.text ?? ""
//            let geoText = cityTextfield.text ?? ""
//            self.descriptionLabel.text = "\(descText)\n\(geoText)"
//        }
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
    
    @objc private func handleTextInputChange(){
        self.placeholderLabel.isHidden = !self.descriptionTextView.text.isEmpty
    }
    
    @objc private func editProfile(){
        enableEditMode(state: clickEdit)
        
        if clickEdit {
            
            clickEdit = !clickEdit
        }else{

            clickEdit = !clickEdit
            
        }
        
        
//        // +++++ Лишний код - начало +++++
//        let alertController = UIAlertController(title: "Настойка профиля", message: "Введите свои данные:", preferredStyle: .alert)
//        let apply = UIAlertAction(title: "Применить", style: .default, handler: {_ in
//            let text = alertController.textFields?[0].text ?? ""
//            if text.split(separator: " ").count >= 2 {
//                
//                self.nameLabel.text = text
//                self.shortName.text = "\(text.split(separator: " ")[0].first ?? "N")\(text.split(separator: " ")[1].first ?? "N")".uppercased()
//            }else {
//                self.nameLabel.text = "No Name"
//                self.shortName.text =  "\(self.nameLabel.text?.split(separator: " ")[0].first ?? "N")\(self.nameLabel.text?.split(separator: " ")[1].first ?? "N")".uppercased()
//            }
//            let descText = alertController.textFields?[1].text ?? ""
//            let geoText = alertController.textFields?[2].text ?? ""
//
//            if descText.count >= 1 {
//                self.descriptionLabel.text = "\(descText)\n\(geoText)"
//            }else{
//                self.descriptionLabel.text = "Opps..."
//            }
//        })
//        
//        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
//        
//        alertController.addAction(apply)
//        alertController.addAction(cancel)
//        alertController.addTextField{ (textField) in
//            textField.placeholder = "Введите имя и фамилию"
//        }
//        alertController.addTextField{ (textField) in
//            textField.placeholder = "Введите информацию о себе"
//        }
//        alertController.addTextField{ (textField) in
//            textField.placeholder = "Страна, город?"
//        }
//        
//        present(alertController, animated: true)
//        // +++++ Лишний код - конец +++++
    }
    //MARK:- Save GCD selector
    @objc private func saveGCD(){
        print(checkEditData())
        checkEditData().saveToFile(name: "userProfile")
        user.initFromFile()
        setupDesign()
        enableEditMode(state: false)
    }
    
    private func checkEditData() -> UserProfileModel{
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
        //self.avatarImageView.image = info[.editedImage] as? UIImage
        self.avatarImageView.setImage(image: info[.editedImage] as? UIImage ?? UIImage(), canAnimate: true)
        let imgData = (self.avatarImageView.image ?? UIImage()).jpegData(compressionQuality: 0.3)
        UserDefaults.standard.set(imgData, forKey: "saveImg")
        self.shortName.isHidden = true
        showEditButton()
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.avatarImageView.image = nil
        self.shortName.isHidden = false
        dismiss(animated: true)
        UserDefaults.standard.set(nil, forKey: "saveImg")

    }
}

    


