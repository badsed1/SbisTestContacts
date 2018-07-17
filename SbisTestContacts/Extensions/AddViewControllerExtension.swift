//
//  AddViewControllerExtension.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 06.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension AddViewController {
    func chooseProfileImage() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhoto = UIAlertAction(title: "Сделать снимок", style: UIAlertActionStyle.default) { (action) in
            self.takeAPickchure(sourse: .camera)
        }
        
        let chooseFormLibrary = UIAlertAction(title: "Выбрать из галереи", style: UIAlertActionStyle.default) { (action) in
            self.takeAPickchure(sourse: .photoLibrary)
        }
        
        let cansel = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil)
        
        [takePhoto, chooseFormLibrary, cansel].forEach({alertController.addAction($0)})
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertController.popoverPresentationController?.sourceView = imageView
            alertController.popoverPresentationController?.sourceRect = imageView.bounds
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func takeAPickchure(sourse: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func saveFriendEntity() {
        if nameTextField.text != nil && surNameTextField.text != nil && secondNameTextField.text != nil && detailTextField.text != nil && phoneTextField.text != nil {
            let humaN = Human(context: coreDataStack.context)
            let phone = Phonenumber(context: coreDataStack.context)

            humaN.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            humaN.bDay = detailTextField.text

            humaN.name = nameTextField.text
            humaN.surName = surNameTextField.text
            humaN.secondName = secondNameTextField.text
            humaN.group = "Friends"
            phone.isWorkPhone = false
            phone.phone = phoneTextField.text.createTruePhoneNumber()

            humaN.phones = NSSet(object: phone)

        }
    }

    func saveCollegaEntity() {
        if nameTextField.text != nil && surNameTextField.text != nil && secondNameTextField.text != nil && detailTextField.text != nil && phoneTextField.text != nil, workPhoneTextField.text != nil {
        let humaN = Human(context: coreDataStack.context)
        let phone = Phonenumber(context: coreDataStack.context)
        
        humaN.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
        humaN.bDay = detailTextField.text
        
        humaN.name = nameTextField.text
        humaN.surName = surNameTextField.text
        humaN.secondName = secondNameTextField.text
        humaN.group = "Work"
        phone.isWorkPhone = true
        phone.phone = phoneTextField.text.createTruePhoneNumber()
        
        humaN.phones = NSSet(object: phone)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        surNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        workPhoneTextField.resignFirstResponder()
        detailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
