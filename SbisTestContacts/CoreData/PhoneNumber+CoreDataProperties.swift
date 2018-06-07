//
//  PhoneNumber+CoreDataProperties.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 05.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//
//

import Foundation
import CoreData


extension PhoneNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumber> {
        return NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber")
    }

    @NSManaged public var isWorkPhone: Bool
    @NSManaged public var phone: String?
    @NSManaged public var human: Human?

}
