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

            human?.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            human?.bDay = extDetail?.text
            human?.name = extName?.text
            human?.surName = extSurName?.text
            human?.secondName = extSecondName?.text
            human?.group = "Friends"
            
            let phone = Phonenumber(context: coreDataStack.context)
            phone.isWorkPhone = false
            phone.phone = extPhone?.text

            let phones = NSSet(object: phone)

            human?.phones = phones
            masterVC?.tableView.reloadData()
        }
    }
//
    func saveCollegaEntity() {
        if extName?.text != nil && extSurName?.text != nil && extSecondName?.text != nil && extDetail?.text != nil && extPhone?.text != nil, extWorkPhone?.text != nil {
            
            human?.avatarPhoto = UIImageJPEGRepresentation(self.imageView.image!, 1) as? NSData
            human?.bDay = nil
            human?.group = "Work"
            human?.name = extName?.text
            human?.surName = extSurName?.text
            human?.secondName = extSecondName?.text
            
            let phone = Phonenumber(context: coreDataStack.context)
            
            phone.isWorkPhone = true
            phone.phone = extPhone?.text

            let phones = NSSet(object: phone)
            human?.phones = phones
        }
    }
}
