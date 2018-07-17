//
//  ColleagueTableViewCell.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

final class ColleagueTableViewCell: BaseTableViewCell {
    
    override var human: Human? {
        didSet {
            if human?.url != nil {
                self.avatarImageView.loadImage(urlString: (human?.url)!)
            } else {
                let imgData = human?.avatarPhoto as Data?
                self.avatarImageView.image = UIImage(data: imgData!)
            }

            fullNameLabel.text = human.unwrapThreeOptionalString(firstData: human?.surName, secondData: human?.name, thirdData: human?.secondName)

            detailLabel.text = human?.bDay
            
            if let phones = self.human?.phones?.allObjects as? [Phonenumber] {
                if (phones.first?.isWorkPhone)! {
                    self.workPhoneNumber.text = phones.first?.phone
                } else {
                self.phoneNumberLabel.text = phones.first?.phone
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let image = self.avatarImageView.image {
                    self.human?.avatarPhoto = UIImageJPEGRepresentation(image, 1) as NSData?
                }
            }
        }
    }
    
    let workTitleLabel: UILabel = {
        let work = UILabel()
        work.translatesAutoresizingMaskIntoConstraints = false
        work.text = "Раб."
        work.textAlignment = .center
        work.font = UIFont.boldSystemFont(ofSize: 14)
        return work
    }()
    
    let workPhoneNumber: UILabel = {
        let workPhone = UILabel()
        workPhone.translatesAutoresizingMaskIntoConstraints = false
        workPhone.textAlignment = .left
        workPhone.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        workPhone.text = ""
        workPhone.font = UIFont.boldSystemFont(ofSize: 16)
        return workPhone
    }()
    
    override func setUpUI() {
        super.setUpUI()
        gradient.endColor = #colorLiteral(red: 0.5678169406, green: 0.3616148786, blue: 1, alpha: 1)
        
        detailLabel.text = "Doljnost"
        
        addSubview(workTitleLabel)
        
        workTitleLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 5).isActive = true
        if #available(iOS 11.0, *) {
            workTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        } else {
            workTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        }
        workTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        workTitleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(workPhoneNumber)
        workPhoneNumber.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 5).isActive = true
        workPhoneNumber.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        workPhoneNumber.trailingAnchor.constraint(equalTo: workTitleLabel.leadingAnchor).isActive = true
        workPhoneNumber.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
