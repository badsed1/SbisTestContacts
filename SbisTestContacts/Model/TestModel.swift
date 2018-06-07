//
//  TestModel.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 07.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation

class AllObjects {
    private var objectsArray: [TestModel]
    
    init() {
        objectsArray = []
    }
    
    func addObject(object: TestModel) {
        self.objectsArray.append(object)
    }
    
    func getCount() -> Int {
        return objectsArray.count
    }
    
    deinit {
        print("conteiner are nil")
    }
}

class TestModel {
    
    let name: String
    let surname: String
    let secondName: String
    let isFreand: Bool
    let avatar: String
    let phone: String
    
    var workPhone: String?
    var bDay: String?
    var workState: String?
    
    init?(name: String, surname: String, secondname: String, isFreand: Bool, avatar: String, phone: String, workPhone: String?, bDay: String?, workState: String?) {
        self.name = name
        self.surname = surname
        self.secondName = secondname
        self.isFreand = isFreand
        self.avatar = avatar
        self.phone = phone
        self.workPhone = workPhone
        self.bDay = bDay
        self.workState = workState
    }
    
    
    deinit {
        print("test model are nil")
    }
    
}

































