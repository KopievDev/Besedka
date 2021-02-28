//
//  ProfileViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 19.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var nameBetweenDesc: NSLayoutConstraint!
    @IBOutlet weak var nameBetweenImage: NSLayoutConstraint!
    @IBOutlet weak var imageBetweenTop: NSLayoutConstraint!
    
    //MARK: - IBAction
    @IBAction func editButtonPressed(_ sender: Any) {
        
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
    
    //MARK: - Variables
    
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init...")
        guard let frame = self.editButton?.frame else { return } // frame = nil
        print("Frame button - \(frame)")
        //print(self.editButton.frame) - Данное представление еще не инициализировано, поэтому приложение упадет при попытки вывести её фрэйм
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    //MARK: - LifeCycle
    // - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.editButton.frame) // (57.5, 587.0, 260.0, 50.0) На данном этапе выводит фрейм не загруженной кнопки - без применения констрейтов  (Как мы задали для iphone se) - В этом методе координаты не изменятся

    }
    
    // - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.editButton.frame) //(77.0, 782.0, 260.0, 50.0) - А тут выводит фрейм подогнанный под экран с помощью констрейтов (iphone 11) ... на разных экранах будут разные координаты
        setupDesign()
    }
    
    //MARK: - Methods
    private func setupDesign(){
        // Setup imageView
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        self.avatarImageView.backgroundColor = UIColor(red: 0.894,
                                                       green: 0.908,
                                                       blue: 0.17,
                                                       alpha: 1)
        self.avatarImageView.contentMode = .scaleAspectFit
        self.avatarImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(_:)))
        self.avatarImageView.addGestureRecognizer(tapGesture)
        
        //Setup label
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        //Setup Button
        self.editButton.layer.cornerRadius = 15
        
        //Check size screen
//        switch self.view.frame.height {
//        
//            case 548.0...568.0://iPhone 5S,SE
//                self.shortName.font = UIFont(name: "Roboto-regular", size: 105)
//                self.descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 12)
//                self.nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 21)
//                self.nameBetweenDesc.constant /= 2
//                self.nameBetweenImage.constant /= 2
//                self.imageBetweenTop.constant /= 2
//            case 647.0...667.0://iPhone 6,7,8 SE2G
//                self.shortName.font = UIFont(name: "Roboto-regular", size: 125)
//                self.descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 14)
//                self.nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
//                
//            case 716.0...736.0://iPhone 6+,7+,8+
//                self.shortName.font = UIFont(name: "Roboto-regular", size: 135)
//                self.descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 16)
//                self.nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
//                
//            case 792...812.0://iPhone X,XS,XR, 11
//                self.shortName.font = UIFont(name: "Roboto-regular", size: 140)
//                self.descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 17)
//                self.nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 25)
//            case 897.0...926.0://iPhone XS_Max
//                self.descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 18)
//                self.nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 27)
//                self.shortName.font = UIFont(name: "Roboto-regular", size: 145)
//            default: print("_____")
//        }
        
        //Get short name from name
        if let name = self.nameLabel.text{
            self.shortName.text = "\(name.split(separator: " ")[0].first ?? "n")\(name.split(separator: " ")[1].first ?? "n")".uppercased()
        }
        
        
    }
    
    // Обработка тапа по картинке - вызываем actionSheet
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
        self.shortName.isHidden = true
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.avatarImageView.image = nil
        self.shortName.isHidden = false
        dismiss(animated: true)
        
    }
}
