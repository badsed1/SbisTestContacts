//
//  AddViewController.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 05.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    weak var masterVC: MasterViewController?
    
    lazy var segmentControll: UISegmentedControl = {
       let segment = UISegmentedControl(items: ["Друг", "Коллега"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(handleSegmentAction), for: UIControlEvents.valueChanged)
        return segment
    }()
    
    @objc func handleSegmentAction() {
        showUpOrHideWorkPhoneField()
        switch segmentControll.selectedSegmentIndex {
        case 0: detailTextField.placeholder = "Введите дату рождения:"
            detailTextField.keyboardType = .decimalPad
        case 1: detailTextField.placeholder = "Введите должность:"
            detailTextField.keyboardType = .default
            default: print(123)
        }
    }
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите имя"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        field.textAlignment = .center
        return field
    }()
    
    lazy var surNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите фамилию"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        field.textAlignment = .center
        return field
    }()
    
    lazy var secondNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите отчество"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        field.textAlignment = .center
        return field
    }()
    
    lazy var workPhoneTextField: VSTextField = {
        let phone = VSTextField()
        if segmentControll.selectedSegmentIndex == 0 {
            phone.alpha = 0.0
        } else {
            phone.alpha = 1.0
        }
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        phone.placeholder = "Введите рабочий номер"
        phone.keyboardType = .namePhonePad
        phone.layer.borderWidth = 1
        phone.layer.borderColor = UIColor.black.cgColor
        phone.layer.cornerRadius = 5
        phone.layer.masksToBounds = true
        phone.delegate = self
        phone.setFormatting("# (###) ###-##-##", replacementChar: "#")
        phone.textAlignment = .center
        return phone
    }()
    
    lazy var detailTextField: UITextField = {
        let detail = UITextField()
        detail.translatesAutoresizingMaskIntoConstraints = false
        
        if segmentControll.selectedSegmentIndex == 0 {
            detail.placeholder = "Ведите дату рождения:"
            detail.inputView = self.datePicker
            detail.inputAccessoryView = self.toolBar
        } else {
            detail.placeholder = "Введите должность:"
        }
        
        detail.layer.borderWidth = 1
        detail.layer.borderColor = UIColor.black.cgColor
        detail.layer.cornerRadius = 5
        detail.layer.masksToBounds = true
        detail.delegate = self
        detail.textAlignment = .center
        return detail
    }()
    
    lazy var phoneTextField: VSTextField = {
        let phone = VSTextField()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.keyboardType = .namePhonePad
        phone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        phone.placeholder = "Введите номер телефона"
        phone.layer.borderWidth = 1
        phone.layer.borderColor = UIColor.black.cgColor
        phone.layer.cornerRadius = 5
        phone.layer.masksToBounds = true
        phone.delegate = self
        phone.setFormatting("# (###) ###-##-##", replacementChar: "#")
        phone.textAlignment = .center
        return phone
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "profileImage")
        img.layer.cornerRadius = 50
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetImageAction)))
        return img
    }()
    
    lazy var datePicker: UIDatePicker = {
       let datePick = UIDatePicker()
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "ru")
        return datePick
    }()
    
    @objc func handleShowDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd.MM.yyyy"
        detailTextField.text = dateFormatter.string(from: datePicker.date)
        detailTextField.resignFirstResponder()
    }
    
    let toolBar: UIToolbar = {
        let bar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 320, height: 44))
        bar.tintColor = .gray
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleShowDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        bar.items = [space, doneButton]
        return bar
    }()
    
    @objc func handleGetImageAction() {
        chooseProfileImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    lazy var saveButton: UIButton = {
       let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Сохранить!", for: UIControlState.normal)
        
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSaveAction), for: UIControlEvents.touchUpInside)
        return btn
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpUI()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    
    func setUpUI() {
        
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        
        view.addSubview(segmentControll)
        
        segmentControll.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        segmentControll.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        segmentControll.heightAnchor.constraint(equalToConstant: 25).isActive = true
        segmentControll.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(nameTextField)
        
        nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(secondNameTextField)
        
        secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        secondNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondNameTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        secondNameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        
        view.addSubview(surNameTextField)
        
        surNameTextField.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 10).isActive = true
        surNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        surNameTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        surNameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        
        view.addSubview(detailTextField)
        
        detailTextField.topAnchor.constraint(equalTo: surNameTextField.bottomAnchor, constant: 10).isActive = true
        detailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailTextField.widthAnchor.constraint(equalTo: surNameTextField.widthAnchor).isActive = true
        detailTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(phoneTextField)
        
        phoneTextField.topAnchor.constraint(equalTo: detailTextField.bottomAnchor, constant: 10).isActive = true
        phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(workPhoneTextField)
        
        workPhoneTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10).isActive = true
        workPhoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        workPhoneTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        workPhoneTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(saveButton)
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: workPhoneTextField.bottomAnchor, constant: 20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        
    }
    
    func createContact() {
        switch segmentControll.selectedSegmentIndex {
        case 0: saveFriendEntity()
        case 1: saveCollegaEntity()
        default: print(123)
        }
    }
    

     func showUpOrHideWorkPhoneField() {
        switch segmentControll.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.workPhoneTextField.alpha = 0
            }, completion: nil)
            
        case 1:
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.workPhoneTextField.alpha = 1
            }, completion: nil)
        default: print(123)
        }
    }
    
    @objc func handleSaveAction() {
        createContact()
        switch segmentControll.selectedSegmentIndex {
        case 0: self.masterVC?.sorting(by: "Friends")
        case 1: self.masterVC?.sorting(by: "Work")
        default: print(123)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
