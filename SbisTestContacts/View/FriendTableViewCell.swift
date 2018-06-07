//
//  FriendTableViewCell.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

final class FriendTableViewCell: BaseTableViewCell {
    
    override var human: Human? {
        didSet {
            let imgData = human?.avatarPhoto as Data?
            avatarImageView.image = UIImage(data: imgData!)
            fullNameLabel.text = human.unwrapThreeOptionalString(firstData: human?.surName, secondData: human?.name, thirdData: human?.secondName)
            
            let index = human?.phoneNumbers?.count
            
            for i in 0..<index! {
                if let phoneNum = human?.phoneNumbers![i] as? PhoneNumber {
                    if !phoneNum.isWorkPhone {
                        if let number = phoneNum.phone {
                            phoneNumberLabel.text = number
                        }
                    }
                }
            }
            
           detailLabel.text = human?.bDay
        }
    }
        
        
    override func setUpUI() {
        super.setUpUI()
        gradient.endColor = #colorLiteral(red: 0.2497825855, green: 0.8004991882, blue: 1, alpha: 1)
    }
        
        
    
}


























