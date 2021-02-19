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
    @IBOutlet weak var shortName: UILabel! {
        didSet {
            shortName.text =  "\(self.nameLabel.text?.split(separator: " ")[0].first ?? "N")\(self.nameLabel.text?.split(separator: " ")[1].first ?? "N")".uppercased()
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    //MARK: - Variables
    
    let tapGesture = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        
    }
    //MARK: - Methods
    private func setupDesign(){
        // Setup imageView
        self.avatarImageView.layer.cornerRadius = 120
        self.avatarImageView.backgroundColor = UIColor(red: 0.894,
                                                       green: 0.908,
                                                       blue: 0.17,
                                                       alpha: 1)
        self.avatarImageView.contentMode = .scaleAspectFit
        self.avatarImageView.clipsToBounds = true
        self.tapGesture.addTarget(self, action: #selector(selectPhoto(_:)))
        self.avatarImageView.addGestureRecognizer(tapGesture)
        //Setup Button
        self.editButton.layer.cornerRadius = 15
        
        
    }
    
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
