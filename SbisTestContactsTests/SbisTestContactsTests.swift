//
//  SbisTestContactsTests.swift
//  SbisTestContactsTests
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//



import XCTest

@testable import SbisTestContacts

class SbisTestContactsTests: XCTestCase {

    var conteiner: AllObjects!
    
    override func setUp() {
        super.setUp()

        conteiner = AllObjects()
        
    }
    
    override func tearDown() {
        super.tearDown()
        conteiner = nil
    }
    
    func testGetJSONData() {
        
        let objectsCounts = 3
        
        let jsonUrl = Bundle.main.url(forResource: "DataSource", withExtension: ".json")
        
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
                
                let namesArray = jsonDictionary!["names"] as? NSArray
                let surnames = jsonDictionary!["surnames"] as? NSArray
                let secondNames = jsonDictionary!["secondnames"] as? NSArray
                let isFreand = jsonDictionary!["isFreand"] as? NSArray
                let bDays = jsonDictionary!["bDays"] as? NSArray
                let photoName = jsonDictionary!["avatar"] as? String
                let workState = jsonDictionary!["workState"] as? String
                let phones = jsonDictionary!["phones"] as? NSArray
                
                for index in 0..<namesArray!.count {
                    if let testModel = TestModel(name: (namesArray![index] as? String)!, surname: (surnames![index] as? String)!, secondname: (secondNames![index] as? String)!, isFreand: (isFreand![index] as! Bool), avatar: photoName!, phone: (phones![index] as? String)!, workPhone: nil, bDay: (bDays![index] as? String)!, workState: workState) {
                        print(testModel.name)
                        conteiner.addObject(object: testModel)
                    }
                }
                
                XCTAssertEqual(objectsCounts, conteiner.getCount(), "")
                
            } catch let err as NSError {
                print(err.localizedDescription)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
