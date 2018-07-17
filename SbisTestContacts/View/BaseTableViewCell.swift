//
//  BaseTableViewCell.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    
    
    var human: Human?
    
    lazy var gradient: GradientView = {
       let grad = GradientView()
        grad.translatesAutoresizingMaskIntoConstraints = false
        return grad
    }()
    
    lazy var avatarImageView: UIImageView = {
       let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.tintColor = .lightGray
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 35
        avatar.layer.masksToBounds = true
        return avatar
    }()
    
    lazy var fullNameLabel: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .left
        name.font = UIFont.boldSystemFont(ofSize: 18)
        return name
    }()
    
    lazy var phoneNumberLabel: UILabel = {
        let phone = UILabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.textAlignment = .left
        phone.font = UIFont.boldSystemFont(ofSize: 16)
        phone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        return phone
    }()
    
    lazy var detailLabel: UILabel = {
       let detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.backgroundColor = .clear
        detail.textAlignment = .center
        detail.font = UIFont.boldSystemFont(ofSize: 14)
        detail.numberOfLines = 0
        return detail
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        addSubview(gradient)
        
        gradient.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradient.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradient.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(avatarImageView)
        
        avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(fullNameLabel)
        
        fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        fullNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(phoneNumberLabel)
        
        phoneNumberLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 5).isActive = true
        phoneNumberLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        phoneNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(detailLabel)
        
        detailLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}





extension Optional {
    func unwrapThreeOptionalString(firstData: String?, secondData: String?, thirdData: String?) -> String? {
        guard let first = firstData, let second = secondData else { return nil}
        if let third = thirdData {
            return first + " " + second + " " + third
        }
        return first + " " + second
    }
    
    static func unwrapp<T>(someData: T?) -> T? {
        guard let someValue = someData else {return nil}
        return someValue
    }
    
}
