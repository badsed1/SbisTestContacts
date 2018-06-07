//
//  Email+CoreDataProperties.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 05.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//
//

import Foundation
import CoreData


extension Email {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Email> {
        return NSFetchRequest<Email>(entityName: "Email")
    }

    @NSManaged public var eMail: String?
    @NSManaged public var human: Human?

}
