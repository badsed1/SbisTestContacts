//
//  AppDelegate.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 01.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var didChooseDetail: Bool = false
    
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        checkCoreDataContent()
        
        let splitViewController = UISplitViewController()
        
        let masterViewController = MasterViewController(style: UITableViewStyle.plain)
        let detailViewController = DetailViewController()
        
        detailViewController.coreDataStack = coreDataStack
        masterViewController.coreDataStack = coreDataStack
        
        let masterNavigationController = UINavigationController(rootViewController: masterViewController)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        
//        masterViewController.presentDel = detailViewController
        
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        splitViewController.delegate = self
        
        
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.preferredPrimaryColumnWidthFraction = 0.7
        window?.rootViewController = splitViewController
        
        
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return !self.didChooseDetail
    }
    
    func checkCoreDataContent() {
        let fetchRequest = NSFetchRequest<Human>(entityName: "Human")
        
        do {
            let count = try coreDataStack.context.fetch(fetchRequest).count
            
            if count == 0 {
                print("CoreData is emty. Start JSON parsing")
                jsonParsing()
            } else {
                print("CoreData does not empty")
                
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    func jsonParsing() {
        let jsonUrl = Bundle.main.url(forResource: "DataSource", withExtension: ".json")
        do {
        let jsonData = try Data(contentsOf: jsonUrl!)
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
                
                let humanEntity = NSEntityDescription.entity(forEntityName: "Human", in: coreDataStack.context)
                
                let namesArray = jsonDictionary!["names"] as? NSArray
                let surnames = jsonDictionary!["surnames"] as? NSArray
                let secondNames = jsonDictionary!["secondnames"] as? NSArray
                let isFreand = jsonDictionary!["isFreand"] as? NSArray
                let bDays = jsonDictionary!["bDays"] as? NSArray
                let photoName = jsonDictionary!["avatar"] as? String
                let workState = jsonDictionary!["workState"] as? String
                let phones = jsonDictionary!["phones"] as? NSArray
                
                for index in 0..<namesArray!.count {
                    
                    let human = Human(entity: humanEntity!, insertInto: coreDataStack.context)
                    
                    human.name = namesArray?[index] as? String
                    human.surName = surnames?[index] as? String
                    human.secondName = secondNames?[index] as? String
                    human.isFreand = isFreand?[index] as! Bool
                    human.bDay = bDays?[index] as? String
                    
                    let freandCheck = isFreand?[index] as! Bool
                    
                    let phoneObject = PhoneNumber(context: coreDataStack.context)
                    let phoneObjectTwo = PhoneNumber(context: coreDataStack.context)
                    
                    
                    if freandCheck {
                        phoneObject.isWorkPhone = false
                        phoneObject.phone = phones?[index] as? String
                        phoneObjectTwo.isWorkPhone = false
                        phoneObjectTwo.phone = nil
                    } else {
                        human.workState = workState
                        phoneObject.isWorkPhone = true
                        phoneObject.phone = "+79999999999"
                        phoneObjectTwo.isWorkPhone = false
                        phoneObjectTwo.phone = phones?[index] as? String
                    }
                    
                    let phones = human.phoneNumbers?.mutableCopy() as? NSMutableOrderedSet
                    
                    phones?.add(phoneObject)
                    phones?.add(phoneObjectTwo)
                    
                    human.phoneNumbers = phones
                    
                    
                    let imageForData = UIImage(named: photoName!)
                    let imgData = UIImageJPEGRepresentation(imageForData!, 1)
                    human.avatarPhoto = imgData as NSData?
                    
                    let emailObject = Email(context: coreDataStack.context)
                    emailObject.eMail = nil
                    
                    let emails = human.email?.mutableCopy() as? NSMutableOrderedSet
                    emails?.add(emailObject)
                    
                    human.email = emails
                }
                
                coreDataStack.saveContext()
                print("Context saved")
                
            } catch let errorr as NSError {
                print(errorr.localizedDescription)
                print("FAIL")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveContext()
    }
}

