//
//  MasterViewController.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 03.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    //  MARK: Variables And Constants
    let cellId = "CellID"
    let cellIDTwo = "CellIDTwo"
    let cellIDThre = "Cell"
    
    var coreDataStack: CoreDataStack!
    
    var fetchedResultController: NSFetchedResultsController<Human>?
    var humans: [Human] = []

    //    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpNavigation()
        fetching()
        
    }
    
    fileprivate func fetching() {
        let fetchRequest: NSFetchRequest<Human> = Human.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescription()]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
//            humans = (fetchedResultController?.fetchedObjects)!
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func setUpTableView() {
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ColleagueTableViewCell.self, forCellReuseIdentifier: cellIDTwo)
        tableView.register(OtherTableViewCell.self, forCellReuseIdentifier: cellIDThre)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setUpNavigation() {
        
        self.navigationItem.title = "Контакты"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleCreateContact))
        
        let sortImage = UIImage(named: "filter")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let button = UIButton(type: .custom)
        button.setImage(sortImage, for: UIControlState.normal)
        button.addTarget(self, action:#selector(handleSortContacts), for:.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc fileprivate func handleCreateContact() {
        let addViewController = AddViewController()
        addViewController.coreDataStack = coreDataStack
        addViewController.masterVC = self
        self.present(UINavigationController(rootViewController: addViewController), animated: true, completion: nil)
    }
    
    @objc func handleSortContacts() {
        let alertController = UIAlertController(title: "Контакты", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let allAction = UIAlertAction(title: "Все контакты", style: UIAlertActionStyle.default) { (action) in
            self.sorting(by: "all")
        }
        
        let worcAction = UIAlertAction(title: "Рабочие контакты", style: UIAlertActionStyle.default) { (action) in
            self.sorting(by: "Work")
        }
        
        let fiendAction = UIAlertAction(title: "Друзья", style: UIAlertActionStyle.default) { (action) in
            self.sorting(by: "Friends")
        }
        
        let dismissAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(allAction)
        alertController.addAction(worcAction)
        alertController.addAction(fiendAction)
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sorting(by group: String) {
        switch group {
        case "all": allSortingFetchRequest()
        case "Friends": wkSortingFetchRequest(sortName: "Friends")
        case "Work": wkSortingFetchRequest(sortName: "Work")
        default:
            print("default")
        }
    }
    
    func allSortingFetchRequest() {
        let fetchRequest: NSFetchRequest<Human> = Human.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Human.group), ascending: false)]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchAndReload()
    }
    
    func wkSortingFetchRequest(sortName: String) {
        let fetchRequest: NSFetchRequest<Human> = Human.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Human.group), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "group", sortName)
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchAndReload()
    }

    
    func fetchAndReload() {
        do {
            try fetchedResultController?.performFetch()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func sortDescription() -> NSSortDescriptor {
        var sort: NSSortDescriptor {
            return NSSortDescriptor(key: #keyPath(Human.surName), ascending: false)
        }
        return sort
    }

    func configuredCell(with human: Human, indexPath: IndexPath) -> BaseTableViewCell {
        if human.group == "Friends" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendTableViewCell
            cell.human = human
            return cell
        } else if human.group == "Work"{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! ColleagueTableViewCell
            cell.human = human
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIDThre, for: indexPath) as! OtherTableViewCell
            cell.human = human
            return cell
        }
    }


}

//    MARK: TableView DataSource
extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultController?.sections?[section] else {return 0}
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let human = fetchedResultController?.object(at: indexPath) else {return UITableViewCell()}
        return configuredCell(with: human, indexPath: indexPath)
    }
}




//    MARK: TableView Delegate
extension MasterViewController {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()

        detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        detailVC.navigationItem.leftItemsSupplementBackButton = true
        detailVC.navigationItem.title = "Detail VC"
        detailVC.coreDataStack = coreDataStack
        detailVC.masterVC = self
        detailVC.human = self.fetchedResultController?.object(at: indexPath)
        
        self.showDetailViewController(UINavigationController(rootViewController: detailVC), sender: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.didChooseDetail = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Delete") { (action, iindexPath) in
            let humanForDelete = self.fetchedResultController?.object(at: indexPath)
            
            self.coreDataStack.context.delete(humanForDelete!)
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension MasterViewController {

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                print("insert item")
            }
            
        case .delete:
            if let indexPath = indexPath {
                print("deleted item")
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }
            
        case .update:
            if let indexPath = indexPath{
                let human = self.fetchedResultController?.object(at: indexPath)
                let _ = configuredCell(with: human!, indexPath: indexPath)
            }

        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.middle)
            }
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

}
