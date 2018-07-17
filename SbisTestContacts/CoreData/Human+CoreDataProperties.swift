//
//  Human+CoreDataProperties.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 12.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//
//

import Foundation
import CoreData


extension Human {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Human> {
        return NSFetchRequest<Human>(entityName: "Human")
    }

    @NSManaged public var avatarPhoto: NSData?
    @NSManaged public var bDay: String?
    @NSManaged public var group: String?
    @NSManaged public var name: String?
    @NSManaged public var secondName: String?
    @NSManaged public var surName: String?
    @NSManaged public var url: String?
    @NSManaged public var doljnost: String?
    @NSManaged public var phones: NSSet?

}

// MARK: Generated accessors for phones
extension Human {

    @objc(addPhonesObject:)
    @NSManaged public func addToPhones(_ value: Phonenumber)

    @objc(removePhonesObject:)
    @NSManaged public func removeFromPhones(_ value: Phonenumber)

    @objc(addPhones:)
    @NSManaged public func addToPhones(_ values: NSSet)

    @objc(removePhones:)
    @NSManaged public func removeFromPhones(_ values: NSSet)

}
