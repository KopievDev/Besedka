//
//  ProfileViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 23.03.2021.
//

import UIKit

// MARK: - Extension UIImagePicker - work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        self.avatarImageView.setImage(image: info[.editedImage] as? UIImage ?? UIImage(), canAnimate: true)

        self.shortName.isHidden = true
        showEditButton()
        disableButton(state: false)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.avatarImageView.image = nil
        self.shortName.isHidden = false
        dismiss(animated: true)
        let fileSaver = FileManagerGCD()
        fileSaver.deleteFile(name: "Avatar.png")
    }
}

// MARK: - Textfield Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dataChecking()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        dataChecking()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        dataChecking()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextfiel:
            self.descriptionTextView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
// MARK: - TextView Delegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        dataChecking()
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        dataChecking()
    }
}
