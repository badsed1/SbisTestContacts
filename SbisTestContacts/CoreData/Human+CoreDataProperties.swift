//
//  Human+CoreDataProperties.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 05.06.2018.
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
    @NSManaged public var isFreand: Bool
    @NSManaged public var name: String?
    @NSManaged public var secondName: String?
    @NSManaged public var surName: String?
    @NSManaged public var workState: String?
    @NSManaged public var email: NSOrderedSet?
    @NSManaged public var phoneNumbers: NSOrderedSet?

}

// MARK: Generated accessors for email
extension Human {

    @objc(insertObject:inEmailAtIndex:)
    @NSManaged public func insertIntoEmail(_ value: Email, at idx: Int)

    @objc(removeObjectFromEmailAtIndex:)
    @NSManaged public func removeFromEmail(at idx: Int)

    @objc(insertEmail:atIndexes:)
    @NSManaged public func insertIntoEmail(_ values: [Email], at indexes: NSIndexSet)

    @objc(removeEmailAtIndexes:)
    @NSManaged public func removeFromEmail(at indexes: NSIndexSet)

    @objc(replaceObjectInEmailAtIndex:withObject:)
    @NSManaged public func replaceEmail(at idx: Int, with value: Email)

    @objc(replaceEmailAtIndexes:withEmail:)
    @NSManaged public func replaceEmail(at indexes: NSIndexSet, with values: [Email])

    @objc(addEmailObject:)
    @NSManaged public func addToEmail(_ value: Email)

    @objc(removeEmailObject:)
    @NSManaged public func removeFromEmail(_ value: Email)

    @objc(addEmail:)
    @NSManaged public func addToEmail(_ values: NSOrderedSet)

    @objc(removeEmail:)
    @NSManaged public func removeFromEmail(_ values: NSOrderedSet)

}

// MARK: Generated accessors for phoneNumbers
extension Human {

    @objc(insertObject:inPhoneNumbersAtIndex:)
    @NSManaged public func insertIntoPhoneNumbers(_ value: PhoneNumber, at idx: Int)

    @objc(removeObjectFromPhoneNumbersAtIndex:)
    @NSManaged public func removeFromPhoneNumbers(at idx: Int)

    @objc(insertPhoneNumbers:atIndexes:)
    @NSManaged public func insertIntoPhoneNumbers(_ values: [PhoneNumber], at indexes: NSIndexSet)

    @objc(removePhoneNumbersAtIndexes:)
    @NSManaged public func removeFromPhoneNumbers(at indexes: NSIndexSet)

    @objc(replaceObjectInPhoneNumbersAtIndex:withObject:)
    @NSManaged public func replacePhoneNumbers(at idx: Int, with value: PhoneNumber)

    @objc(replacePhoneNumbersAtIndexes:withPhoneNumbers:)
    @NSManaged public func replacePhoneNumbers(at indexes: NSIndexSet, with values: [PhoneNumber])

    @objc(addPhoneNumbersObject:)
    @NSManaged public func addToPhoneNumbers(_ value: PhoneNumber)

    @objc(removePhoneNumbersObject:)
    @NSManaged public func removeFromPhoneNumbers(_ value: PhoneNumber)

    @objc(addPhoneNumbers:)
    @NSManaged public func addToPhoneNumbers(_ values: NSOrderedSet)

    @objc(removePhoneNumbers:)
    @NSManaged public func removeFromPhoneNumbers(_ values: NSOrderedSet)

}
