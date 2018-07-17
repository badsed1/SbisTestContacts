//
//  SbisTestContactsTests.swift
//  SbisTestContactsTests
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//



import XCTest
import CoreData


@testable import SbisTestContacts

class SbisTestContactsTests: XCTestCase {
    
    var appDelegete: AppDelegate!
    
    var firstPerson: Person!
    var secondPerson: Person!
    var thirdPerson: Person!
    
    var firstDay: BirthDay!
    var secondDay: BirthDay!
    var thirdDay: BirthDay!
    
    var testDataArray: Array<Person> = []
    
    
    override func setUp() {
        super.setUp()
        
        appDelegete = AppDelegate()
        
        firstDay = BirthDay(year: 1959, month: 4, day: 23)
        secondDay = BirthDay(year: 1989, month: 3, day: 4)
        thirdDay = BirthDay(year: 1989, month: 3, day: 13)
        
        
        firstPerson = Person(name: "Sergey", lastname: "Bogdanov", secondname: nil, group: "Friends", phone: "+79523753625", avatar: nil, birthday: firstDay)
        secondPerson = Person(name: "Evgeniy", lastname: "Stadnik", secondname: "Dmitrievich", group: nil, phone: "+7 (921) 554 11 99", avatar: nil, birthday: secondDay)
        thirdPerson = Person(name: "Dmitriy", lastname: "Popov", secondname: "Egorovich", group: "Work", phone: "8(911)007-75-07", avatar: nil, birthday: thirdDay)
        
        testDataArray.append(firstPerson)
        testDataArray.append(secondPerson)
        testDataArray.append(thirdPerson)
    }
    
    override func tearDown() {
        super.tearDown()
        appDelegete = nil
        firstPerson = nil
        secondPerson = nil
        thirdPerson = nil
        firstDay = nil
        secondDay = nil
        thirdDay = nil
    }
    
    func testParseData() {
        guard let url = Bundle.main.url(forResource: "contacts", withExtension: ".json") else {fatalError("Bad URL")}
        for _ in 0...10 {
            appDelegete.getdataFromJson(by: url) { (persons, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                guard let persons = persons else {fatalError("Bad array")}
                let sortedPersons = persons.sorted(by: {$0.name! < $1.name!})
                let sortedTestData = self.testDataArray.sorted(by: {$0.name! < $1.name!})
                
                XCTAssertEqual(sortedPersons.first?.name, sortedTestData.first?.name)
                print("Ok")
            }
        }
    }
    
    func testEncodeData() {
        let persondata = try? JSONEncoder().encode(testDataArray)
        
        guard let url = Bundle.main.url(forResource: "contacts", withExtension: ".json") else {fatalError("Bad URL")}
        appDelegete.getdataFromJson(by: url) { (persons, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let persons = persons else {fatalError("Bad array")}
            let dataFromJson = try? JSONEncoder().encode(persons)
            
            let sortedPersons = try? JSONDecoder().decode([Person].self, from: persondata!).sorted(by: {$0.phone! < $1.phone!})
            let sortedTestData = try? JSONDecoder().decode([Person].self, from: dataFromJson!).sorted(by: {$0.phone! < $1.phone!})
            
            XCTAssertEqual(sortedPersons?.first?.name, sortedTestData?.first?.name)
        }
    }
    
    func testObjectEncodeDecode() {
        print("\n\n123123\n\n")
    }
}














