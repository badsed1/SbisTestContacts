//
//  DetailViewControllerExtension.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 07.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension DetailViewController {
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
        if extName?.text != nil && extSurName?.text != nil && extSecondName?.text != nil && extDetail?.text != nil && extPhone?.text != nil {

            let phoneEntity = NSEntityDescription.entity(forEntityName: "PhoneNumber", in: coreDataStack.context)
            let emailEntity = NSEntityDescription.entity(forEntityName: "Email", in: coreDataStack.context)

            let phone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let email = Email(entity: emailEntity!, insertInto: coreDataStack.context)
            
            human?.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            human?.bDay = extDetail?.text
            human?.isFreand = true
            human?.name = extName?.text
            human?.surName = extSurName?.text
            human?.secondName = extSecondName?.text
            human?.workState = nil
            phone.isWorkPhone = false
            phone.phone = extPhone?.text
            email.eMail = "badsed1@gmail.com"
            
            let phones = human?.phoneNumbers?.mutableCopy() as? NSMutableOrderedSet
            let emails = human?.email?.mutableCopy() as? NSMutableOrderedSet
            
            emails?.add(email)
            phones?.add(phone)
            human?.phoneNumbers = phones
            human?.email = emails
            
            coreDataStack.saveContext()
        }
    }
    
    func saveCollegaEntity() {
        if extName?.text != nil && extSurName?.text != nil && extSecondName?.text != nil && extDetail?.text != nil && extPhone?.text != nil, extWorkPhone?.text != nil {
            
            let phoneEntity = NSEntityDescription.entity(forEntityName: "PhoneNumber", in: coreDataStack.context)
            let emailEntity = NSEntityDescription.entity(forEntityName: "Email", in: coreDataStack.context)

            let phone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let workPhone = PhoneNumber(entity: phoneEntity!, insertInto: coreDataStack.context)
            let email = Email(entity: emailEntity!, insertInto: coreDataStack.context)
            
            human?.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            human?.bDay = nil
            human?.workState = extDetail?.text
            human?.isFreand = false
            human?.name = extName?.text
            human?.surName = extSurName?.text
            human?.secondName = extSecondName?.text
            phone.isWorkPhone = false
            phone.phone = extPhone?.text
            workPhone.isWorkPhone = true
            workPhone.phone = extWorkPhone?.text
            email.eMail = "badsed1@gmail.com"
            
            let phones = human?.phoneNumbers?.mutableCopy() as? NSMutableOrderedSet
            let emails = human?.email?.mutableCopy() as? NSMutableOrderedSet
            
            emails?.add(email)
            phones?.add(phone)
            phones?.add(workPhone)
            human?.phoneNumbers = phones
            human?.email = emails
            
            coreDataStack.saveContext()
        }
    }
}
