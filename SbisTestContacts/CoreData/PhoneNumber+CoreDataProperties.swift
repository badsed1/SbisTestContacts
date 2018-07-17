//
//  Phonenumber+CoreDataProperties.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 12.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//
//

import Foundation
import CoreData


extension Phonenumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phonenumber> {
        return NSFetchRequest<Phonenumber>(entityName: "Phonenumber")
    }

    @NSManaged public var phone: String?
    @NSManaged public var isWorkPhone: Bool
    @NSManaged public var human: Human?

}
