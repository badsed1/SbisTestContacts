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
            let humaEntity = NSEntityDescription.entity(forEntityName: "Human", in: coreDataStack.context)
            let phoneEntity = NSEntityDescription.entity(forEntityName: "PhoneNumber", in: coreDataStack.context)
            let emailEntity = NSEntityDescription.entity(forEntityName: "Email", in: coreDataStack.context)
            
            let humaN = Human(entity: humaEntity!, insertInto: coreDataStack.context)
            let phone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let email = Email(entity: emailEntity!, insertInto: coreDataStack.context)
            
            humaN.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            humaN.bDay = detailTextField.text
            humaN.isFreand = true
            humaN.name = nameTextField.text
            humaN.surName = surNameTextField.text
            humaN.secondName = secondNameTextField.text
            humaN.workState = nil
            phone.isWorkPhone = false
            phone.phone = phoneTextField.text
            email.eMail = "badsed1@gmail.com"
            
            let phones = humaN.phoneNumbers?.mutableCopy() as? NSMutableOrderedSet
            let emails = humaN.email?.mutableCopy() as? NSMutableOrderedSet
            
            emails?.add(email)
            phones?.add(phone)
            humaN.phoneNumbers = phones
            humaN.email = emails
            
            coreDataStack.saveContext()
        }
    }
    
    func saveCollegaEntity() {
        if nameTextField.text != nil && surNameTextField.text != nil && secondNameTextField.text != nil && detailTextField.text != nil && phoneTextField.text != nil, workPhoneTextField.text != nil {
            let humaEntity = NSEntityDescription.entity(forEntityName: "Human", in: coreDataStack.context)
            let phoneEntity = NSEntityDescription.entity(forEntityName: "PhoneNumber", in: coreDataStack.context)
            let emailEntity = NSEntityDescription.entity(forEntityName: "Email", in: coreDataStack.context)
            
            let humaN = Human(entity: humaEntity!, insertInto: coreDataStack.context)
            let phone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let workPhone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let email = Email(entity: emailEntity!, insertInto: coreDataStack.context)
            
            humaN.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            humaN.bDay = nil
            humaN.workState = detailTextField.text
            humaN.isFreand = false
            humaN.name = nameTextField.text
            humaN.surName = surNameTextField.text
            humaN.secondName = secondNameTextField.text
            phone.isWorkPhone = false
            phone.phone = phoneTextField.text
            workPhone.isWorkPhone = true
            workPhone.phone = workPhoneTextField.text
            email.eMail = "badsed1@gmail.com"
            
            let phones = humaN.phoneNumbers?.mutableCopy() as? NSMutableOrderedSet
            let emails = humaN.email?.mutableCopy() as? NSMutableOrderedSet
            
            emails?.add(email)
            phones?.add(phone)
            phones?.add(workPhone)
            humaN.phoneNumbers = phones
            humaN.email = emails
            
            coreDataStack.saveContext()
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
