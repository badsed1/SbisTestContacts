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

protocol PresentDetailViewControllerDelegate: AnyObject {
    func presentDelegate(text: String)
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    //  MARK: Variables And Constants
    let cellId = "CellID"
    let cellIDTwo = "CellIDTwo"
    
    var coreDataStack: CoreDataStack!
    
    weak var presentDel: PresentDetailViewControllerDelegate?
    
    var fetchedResultController: NSFetchedResultsController<Human>?
    var humans: [Human] = []
    
    lazy var segmentControll: UISegmentedControl = {
       let segment = UISegmentedControl(items: ["Все контакты","Друзья", "Работа"])
        segment.frame = CGRect(x: 0.0, y: 0.0, width: 150, height: 35)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(handleSegmentControllAction), for: UIControlEvents.valueChanged)
        return segment
    }()
    
    @objc func handleSegmentControllAction(_ sender: UISegmentedControl) {
        sorting()
    }
    
    
    let dataArray = ["CellID", "CellID", "CellID", "CellID", "CellID", "CellID"]
    //    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ColleagueTableViewCell.self, forCellReuseIdentifier: cellIDTwo)
        tableView.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.titleView = segmentControll
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleCreateContact))
        
        
        
        let fetchRequest: NSFetchRequest<Human> = Human.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescription()]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
           try fetchedResultController?.performFetch()
            humans = (fetchedResultController?.fetchedObjects)!
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        fetchedResultController?.delegate = self
    }
    
    @objc fileprivate func handleCreateContact() {
        let addViewController = AddViewController()
        addViewController.coreDataStack = coreDataStack
        addViewController.masterVC = self
        self.present(UINavigationController(rootViewController: addViewController), animated: true, completion: nil)
    }
    
    func sorting() {
        let fetchRequest: NSFetchRequest<Human> = Human.fetchRequest()
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = nil
        if segmentControll.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Human.surName), ascending: true)]
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchAndReload()
        } else if segmentControll.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Human.isFreand), ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "%K == true", #keyPath(Human.isFreand))
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchAndReload()
        } else {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Human.isFreand), ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "%K == false", #keyPath(Human.isFreand))
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchAndReload()
        }
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

    func configuredCell(isFreand: Bool, indexPath: IndexPath) -> BaseTableViewCell {
        if isFreand {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! ColleagueTableViewCell
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
        let human = fetchedResultController?.object(at: indexPath)
        
        let cell = configuredCell(isFreand: human!.isFreand, indexPath: indexPath)
        cell.human = human
        return cell
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
        detailVC.human = fetchedResultController?.object(at: indexPath)
        
        
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
            self.coreDataStack.saveContext()
            self.sorting()
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
            }
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.left)
            
        case .update:
            
            let updatedHuman = fetchedResultController?.object(at: indexPath!)
            if (updatedHuman?.isFreand)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath!) as! FriendTableViewCell
                cell.human = updatedHuman
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath!) as! ColleagueTableViewCell
                cell.human = updatedHuman
            }

        case .move:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.none)
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.middle)
        }
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}


































