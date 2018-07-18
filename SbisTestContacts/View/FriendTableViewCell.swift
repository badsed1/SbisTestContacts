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
            if human?.url != nil {
//                self.avatarImageView.loadImage(urlString: (human?.url)!)
            } else {
                let imgData = human?.avatarPhoto as Data?
                self.avatarImageView.image = UIImage(data: imgData!)
            }

            fullNameLabel.text = human.unwrapThreeOptionalString(firstData: human?.surName, secondData: human?.name, thirdData: human?.secondName)

           detailLabel.text = human?.bDay
            if let phones = self.human?.phones?.allObjects as? [Phonenumber] {
                self.phoneNumberLabel.text = phones.first?.phone
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned avatarImageView] in
//                if let image = avatarImageView.image {
//                    self.human?.avatarPhoto = UIImageJPEGRepresentation(image, 1) as NSData?
//                }
//            }
        }
    }
    
        
    override func setUpUI() {
        super.setUpUI()
        gradient.endColor = #colorLiteral(red: 0.2497825855, green: 0.8004991882, blue: 1, alpha: 1)
    }

}


























