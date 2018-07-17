//
//  UIViewControllerExtension.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 06.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController: UITextFieldDelegate {
    var nameTextField: UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите имя"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        return field
    }
    
    var surNameTextField: UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите фамилию"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        return field
    }
    
    var secondNameTextField: UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.placeholder = "Введите отчество"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 5
        field.layer.masksToBounds = true
        field.delegate = self
        return field
    }
    
    var workPhoneTextField: VSTextField {
        let phone = VSTextField()
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
        return phone
    }
    
    var detailTextField: UITextField {
        let detail = UITextField()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.layer.borderWidth = 1
        detail.layer.borderColor = UIColor.black.cgColor
        detail.layer.cornerRadius = 5
        detail.layer.masksToBounds = true
        detail.delegate = self
        return detail
    }
    
    
    
    var phoneTextField: VSTextField {
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
        return phone
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        surNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        workPhoneLabel.resignFirstResponder()
        detailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
