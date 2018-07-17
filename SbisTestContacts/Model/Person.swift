//
//  ContactModel.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 09.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

struct Person: CustomStringConvertible {
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

extension Person: Decodable, Encodable {
    enum MyCodingkeys: String, CodingKey {
        case name = "name"
        case lastname = "lastname"
        case secondname = "middleame"
        case group
        case phone = "phone"
        case birthday = "birthday"
        case ava = "avatar"
    }
    
    init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: MyCodingkeys.self)
        let name = try? conteiner.decode(Safe<String>.self, forKey: .name)
        let lastname = try? conteiner.decode(Safe<String>.self, forKey: .lastname)
        let secondname = try? conteiner.decode(Safe<String>.self, forKey: .secondname)
        let group = try? conteiner.decode(Safe<String>.self, forKey: .group)
        let phone = try? conteiner.decode(Safe<String>.self, forKey: .phone)
        let birthday = try? conteiner.decode(Safe<BirthDay>.self, forKey: .birthday)
        let avatar = try? conteiner.decode(Safe<String>.self, forKey: .ava)
        
        self.init(name: name?.value, lastname: lastname?.value, secondname: secondname?.value, group: group?.value, phone: phone?.value, avatar: avatar?.value, birthday: birthday?.value)
    }
    
    func encode(to encoder: Encoder) throws {
        var conteiner = encoder.container(keyedBy: MyCodingkeys.self)
        try conteiner.encode(name, forKey: .name)
        try conteiner.encode(lastname, forKey: .lastname)
        try conteiner.encode(secondname, forKey: .secondname)
        try conteiner.encode(group, forKey: .group)
        try conteiner.encode(phone, forKey: .phone)
        try conteiner.encode(birthday, forKey: .birthday)
        try conteiner.encode(avatar, forKey: .ava)
    }
}

struct BirthDay {
    var year: Int?
    var month: Int?
    var day: Int?
    
    
    func getDay() -> String {
        return "\(self.day ?? 0) \(self.month ?? 0) \(self.year ?? 0)"
    }
}

extension BirthDay: Decodable, Encodable {
    enum MyCodingKeyForBDay: String, CodingKey {
        case year = "year"
        case month = "month"
        case day = "day"
    }
    
    init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: MyCodingKeyForBDay.self)
        let year = try conteiner.decode(Safe<Int>.self, forKey: .year)
        let month = try conteiner.decode(Safe<Int>.self, forKey: .month)
        let day = try conteiner.decode(Safe<Int>.self, forKey: .day)
        
        self.init(year: year.value, month: month.value, day: day.value)
    }
    
    func encode(to encoder: Encoder) throws {
        var conteiner = encoder.container(keyedBy: MyCodingKeyForBDay.self)
        try conteiner.encode(year, forKey: .year)
        try conteiner.encode(month, forKey: .month)
        try conteiner.encode(day, forKey: .day)
    }
}


public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }
}








