//
//  DetailViewController.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 03.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //    var isEditingContact = false
    
    var coreDataStack: CoreDataStack!
    
    weak var masterVC: MasterViewController?
    
    var human: Human? {
        didSet {
            if human?.avatarPhoto != nil {
                if let image = UIImage(data: (human?.avatarPhoto as Data?)!) {
                    self.imageView.image = image
                } else {
                    self.imageView.image = UIImage(named: "profileImage")
                }
            } else {
                self.imageView.image = UIImage(named: "profileImage")
            }

            nameLabel.text = human.unwrapThreeOptionalString(firstData: human?.surName, secondData: human?.name, thirdData: human?.secondName)
            setUpDetailTextLabel()
            setUpPhones()
            
        }
    }
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    let workPhoneLabel: UILabel = {
        let phone = UILabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.textAlignment = .center
        phone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        phone.isUserInteractionEnabled = true
        return phone
    }()
    
    let detailLabel: UILabel = {
        let detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.textAlignment = .center
        return detail
    }()
    
    lazy var callGesture = UITapGestureRecognizer(target: self, action: #selector(handleMakeCall))
    
    let phoneLabel: CopyLabel = {
        let phone = CopyLabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.textAlignment = .center
        phone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        phone.isUserInteractionEnabled = true
        return phone
    }()
    
    @objc func handleMakeCall() {
        print("CAAAALLLLLLLL")
        guard let number = URL(string: "tel://" + setUpPhonesForEdit()) else { return }
        UIApplication.shared.open(number)
    }
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 50
        img.layer.masksToBounds = true
        
        return img
    }()
    
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
    
    lazy var cancelEditingButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Отмена!", for: UIControlState.normal)
        btn.layer.borderWidth = 1
        btn.backgroundColor = .red
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleCancelAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var barButtonItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleActionButton))
        return btn
    }()
    
    weak var extName: UITextField?
    weak var extSurName: UITextField?
    weak var extSecondName: UITextField?
    weak var extDetail: UITextField?
    weak var extPhone: UITextField?
    weak var extWorkPhone: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        self.navigationItem.rightBarButtonItem = barButtonItem
        phoneLabel.gestureRecognizers = [callGesture]
        workPhoneLabel.gestureRecognizers = [callGesture]
        
        phoneLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture)))
    }
    
    @objc func handleLongPressGesture(sender: UIGestureRecognizer) {
            guard sender.state == .began, let senderView = sender.view, let superView = sender.view?.superview else {
                return
            }
            
            senderView.becomeFirstResponder()
        
            let saveMenuItem = UIMenuItem(title: "Сохранить", action: #selector(saveTapped))

            UIMenuController.shared.menuItems = [saveMenuItem]
            UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
            UIMenuController.shared.setMenuVisible(true, animated: true)
       
    }
    
    @objc func saveTapped() {
        phoneLabel.copy(sender: nil)
        phoneLabel.resignFirstResponder()
    }
    
    func setUpUI() {
        
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(detailLabel)
        
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(phoneLabel)
        
        phoneLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10).isActive = true
        phoneLabel.centerXAnchor.constraint(equalTo: detailLabel.centerXAnchor).isActive = true
        phoneLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    fileprivate func setUpWoringPhoneLabel() {
        view.addSubview(workPhoneLabel)
        
        workPhoneLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10).isActive = true
        workPhoneLabel.centerXAnchor.constraint(equalTo: phoneLabel.centerXAnchor).isActive = true
        workPhoneLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        workPhoneLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    //    MARK: AlertController
    @objc func handleActionButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let addAlertAction = UIAlertAction(title: "Добавить новый контак", style: UIAlertActionStyle.default) { (action) in
            let addController = AddViewController()
            addController.coreDataStack = self.coreDataStack
            addController.masterVC = self.masterVC
            self.present(UINavigationController(rootViewController: addController), animated: true, completion: nil)
        }
        
        let editAction = UIAlertAction(title: "Редактировать текущий контакт", style: UIAlertActionStyle.default) { (action) in
            self.editCurrentContact()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.destructive, handler: nil)
        
        alertController.addAction(addAlertAction)
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.barButtonItem = barButtonItem
            alertController.popoverPresentationController?.sourceView = self.view
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    fileprivate func editCurrentContact() {
        addUIElements()
    }
    
    @objc fileprivate func handleSaveAction() {
                switch human?.group {
                case "Work": saveCollegaEntity()
                    removeUIElements()
                case "Friends": saveFriendEntity()
                    removeUIElements()
                default: print("Error saving")
                }
    }
    
    @objc func handleCancelAction() {
        let image = UIImage(data: (human?.avatarPhoto as? Data)!)
        imageView.image = image
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.isUserInteractionEnabled = false
        nameLabel.isHidden = false
        phoneLabel.isHidden = false
        detailLabel.isHidden = false
                if human?.group == "Freands" {
                    workPhoneLabel.isHidden = true
                } else {
                    workPhoneLabel.isHidden = false
                }
        extName?.removeFromSuperview()
        extPhone?.removeFromSuperview()
        extDetail?.removeFromSuperview()
        extWorkPhone?.removeFromSuperview()
        cancelEditingButton.removeFromSuperview()
    }
    
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
    
    fileprivate func setUpDetailTextLabel() {
                if let human = human {
                    if  human.group == "Friends" {
                        if let bDay = human.bDay {
                            detailLabel.text = "День рождения: " + bDay
                        }
                    } else {
                        if let doljnost = human.doljnost {
                            detailLabel.text = "Должность: " + doljnost
                        }
                    }
                }
    }
    
    fileprivate func setUpPhones() {
        
        if let phones = human?.phones?.allObjects as? [Phonenumber] {
            if let phone = phones.first {
                if !phone.isWorkPhone {
                    phoneLabel.text = phone.phone
                } else {
                    setUpWoringPhoneLabel()
                    workPhoneLabel.text = phone.phone
                }
            }
        }
    }
    
    fileprivate func setUpPhonesForEdit() -> String{
                var numberToReturn: String = ""
        
        if let phones = human?.phones?.allObjects as? [Phonenumber] {
            if let phone = phones.first {
                numberToReturn = phone.phone ?? ""
            }
        }
        return numberToReturn
    }
    
    lazy var datePicker: UIDatePicker = {
        let datePick = UIDatePicker()
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "ru")
        return datePick
    }()
    
    @objc func handleShowDatePicker() {
        print("Date picker")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd.MM.yyyy"
        extDetail?.text = dateFormatter.string(from: datePicker.date)
        extDetail?.resignFirstResponder()
    }
    
    let toolBar: UIToolbar = {
        let bar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 320, height: 44))
        bar.tintColor = .gray
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleShowDatePicker))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        bar.items = [space, doneButton]
        return bar
    }()
}



extension DetailViewController {
    private func addUIElements() {
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.green.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetImageAction)))
        nameLabel.isHidden = true
        phoneLabel.isHidden = true
        detailLabel.isHidden = true
        workPhoneLabel.isHidden = true
        
        
        extName = nameTextField
        extSurName = surNameTextField
        extSecondName = secondNameTextField
        extDetail = detailTextField
        extPhone = phoneTextField
        extWorkPhone = workPhoneTextField
        
        view.addSubview(extName!)
        extName?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extName?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        extName?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extName?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        extName?.text = human?.name
        
        view.addSubview(extSecondName!)
        extSecondName?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extSecondName?.topAnchor.constraint(equalTo: (extName?.bottomAnchor)!, constant: 10).isActive = true
        extSecondName?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extSecondName?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        extSecondName?.text = human?.secondName
        
        view.addSubview(extSurName!)
        extSurName?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extSurName?.topAnchor.constraint(equalTo: (extSecondName?.bottomAnchor)!, constant: 10).isActive = true
        extSurName?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extSurName?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        extSurName?.text = human?.surName
        
        view.addSubview(extDetail!)
        extDetail?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extDetail?.topAnchor.constraint(equalTo: (extSurName?.bottomAnchor)!, constant: 10).isActive = true
        extDetail?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extDetail?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
                if human?.group == "Friends" || human?.group == "All" {
                    extDetail?.text = human?.bDay
                    extDetail?.inputView = self.datePicker
                    extDetail?.inputAccessoryView = self.toolBar
                } else {
                    extDetail?.text = human?.doljnost
                }
        
        
        
        
        view.addSubview(extPhone!)
        extPhone?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extPhone?.topAnchor.constraint(equalTo: (extDetail?.bottomAnchor)!, constant: 10).isActive = true
        extPhone?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extPhone?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        extPhone?.text = setUpPhonesForEdit()
        
        
        view.addSubview(extWorkPhone!)
        extWorkPhone?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extWorkPhone?.topAnchor.constraint(equalTo: (extPhone?.bottomAnchor)!, constant: 10).isActive = true
        extWorkPhone?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        extWorkPhone?.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        extWorkPhone?.text = setUpPhonesForEdit()
        extWorkPhone?.alpha = 0.0
            if !(human?.group == "Friends") {
                extWorkPhone?.alpha = 1.0
            }
        
        view.addSubview(saveButton)
        
        saveButton.leadingAnchor.constraint(equalTo: (extWorkPhone?.leadingAnchor)!).isActive = true
        saveButton.topAnchor.constraint(equalTo: (extWorkPhone?.bottomAnchor)!, constant: 10).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        view.addSubview(cancelEditingButton)
        
        cancelEditingButton.trailingAnchor.constraint(equalTo: (extWorkPhone?.trailingAnchor)!).isActive = true
        cancelEditingButton.topAnchor.constraint(equalTo: (extWorkPhone?.bottomAnchor)!, constant: 10).isActive = true
        cancelEditingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelEditingButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func removeUIElements() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.isUserInteractionEnabled = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetImageAction)))
        nameLabel.text = (extSurName?.text)! + " " + (extName?.text)! + " " + (extSecondName?.text)!
        phoneLabel.text = extPhone?.text
                if human?.group == "Friends" {
                    detailLabel.text = "День рождения: " + (extDetail?.text)!
                } else {
                    detailLabel.text = "Должность: " + (extDetail?.text)!
                }
        
        
        
        nameLabel.isHidden = false
        phoneLabel.isHidden = false
        detailLabel.isHidden = false
        
                if human?.group == "Friends" {
                    workPhoneLabel.isHidden = true
                } else {
                    workPhoneLabel.text = extWorkPhone?.text
                    workPhoneLabel.isHidden = false
                }
        extName?.removeFromSuperview()
        extPhone?.removeFromSuperview()
        extDetail?.removeFromSuperview()
        extWorkPhone?.removeFromSuperview()
        cancelEditingButton.removeFromSuperview()
    }
}









