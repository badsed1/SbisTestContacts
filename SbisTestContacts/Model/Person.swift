//
//  ContactModel.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 09.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

struct Person: Codable, CustomStringConvertible {
    var name: String?
    var lastname: String?
    var secondname: String?
    var group: String?
    var phone: String?
    var avatar: String?
    var birthday: BirthDay?
    
    var description: String {
        return " name - \(name ?? "nil") \n lastName - \(lastname ?? "nil") \n secondname - \(secondname ?? "nil") \n group - \(group ?? "nil") \n phone - \(phone ?? "nil") \n bDay - \(birthday!.year ?? 00) \(birthday!.month ?? 00) \(birthday!.day ?? 00) \n Avatar - \(avatar ?? "nil") \n\n"
    }
}

extension Person {
    enum CodingKeys: String, CodingKey {
        case name
        case lastname
        case secondname = "middleame"
        case group
        case phone
        case avatar
        case birthday
    }
}

struct BirthDay: Codable {
    var year: Int?
    var month: Int?
    var day: Int?
    
    
    func getDay() -> String {
        return "\(self.day ?? 0) \(self.month ?? 0) \(self.year ?? 0)"
    }
}
