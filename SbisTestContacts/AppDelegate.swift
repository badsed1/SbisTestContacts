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
    
    var coreDataStack = CoreDataStack()
    
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
                
                guard let url = Bundle.main.url(forResource: "contacts", withExtension: ".json") else {fatalError("BAD URL")}
                
                getdataFromJson(by: url) { (persons, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    insertDataToContext(persons)
                }
            } else {
                print("CoreData does not empty")
            }
            
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func getdataFromJson(by url: URL, completion: ([Person]?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            let jsonArray = try JSONDecoder().decode([Person].self, from: data)
            completion(jsonArray, nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    
    func insertDataToContext(_ aJsonArray: [Person]?) {
        
        guard let jsonArray = aJsonArray else {fatalError("BAD ARRAY - \(String(describing: aJsonArray?.count))")}
        
        for value in jsonArray {
            let human = Human(context: coreDataStack.context)
            let phone = Phonenumber(context: coreDataStack.context)
            
            if value.avatar == nil {
                let imageForData = UIImage(named: "profileImage")
                let imgData = UIImageJPEGRepresentation(imageForData!, 1) as NSData?
                human.avatarPhoto = imgData
            } else {
                human.url = value.avatar
                let imageForData = UIImage(named: "profileImage")
                let imgData = UIImageJPEGRepresentation(imageForData!, 1) as NSData?
                human.avatarPhoto = imgData
            }
            
            if value.group == nil {
                human.group = "all"
                
            } else {
                human.group = value.group
            }
            
            human.name = value.name
            human.secondName = value.secondname
            human.surName = value.lastname
            human.bDay = value.birthday?.getDay()
            phone.phone = value.phone?.createTruePhoneNumber()
            if human.group == "Work" {
                phone.isWorkPhone = true
            } else {
                phone.isWorkPhone = false
            }
            human.phones = NSSet(object: phone)
            
            print(human.description)
        }
//        coreDataStack.saveContext()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        coreDataStack.saveContext()
        print("Saveing data")
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
        print("Saveing data")
    }
}

