//
//  ProfileViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 23.03.2021.
//

import UIKit

// MARK: - Extension UIImagePicker - work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setAvatar(_ image: UIImage) {
        profile.avatarImageView.setImage(image: image, canAnimate: true)
        profile.shortName.isHidden = true
        profile.showEditButton()
        profile.disableButton(state: false)
        dismiss(animated: true)
    }
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        setAvatar(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profile.avatarImageView.image = nil
        profile.shortName.isHidden = false
        dismiss(animated: true)
        store.deleteFile(name: "Avatar.png")
    }
}

// MARK: - Textfield Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        profile.dataChecking()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        profile.dataChecking()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        profile.dataChecking()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case profile.userNameTextfiel:
            profile.descriptionTextView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
// MARK: - TextView Delegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        profile.dataChecking()
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        profile.dataChecking()
    }
}
