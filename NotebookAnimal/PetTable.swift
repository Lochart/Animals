//
//  NotebookPet.swift
//  NotebookAnimal
//
//  Created by Nikolay on 21.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import UIKit
import CoreData


class PetTable: UITableViewController, NSFetchedResultsControllerDelegate {

    var notebookAnimals: [NotebookAnimal] = []
    var fetchResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "NotebookAnimal")
        let sortDescriptor = NSSortDescriptor(key: "namePet", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                notebookAnimals = fetchResultController.fetchedObjects as! [NotebookAnimal]
            } catch {
                print(error)
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notebookAnimals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PetTableCell
        
        let notebookAnimal = notebookAnimals[indexPath.row]
        
        // Настройка ячейки
        cell.namePetLabel.text = notebookAnimal.namePet
        cell.kindOfAnimalLabel.text = notebookAnimal.kindOfPet
        
        return cell
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _newIndexPath = newIndexPath {
                tableView.deleteRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _newIndexPath = newIndexPath {
                tableView.reloadRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        notebookAnimals = controller.fetchedObjects as! [NotebookAnimal]
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //Delete
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(actin, indexPath) -> Void in
            self.notebookAnimals.removeAtIndex(indexPath.row)
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let restarauntToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! NotebookAnimal
                
                managedObjectContext.deleteObject(restarauntToDelete)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        return [deleteAction]
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    @IBAction func unwindToNotebookAnimals(segue: UIStoryboardSegue) {

    }

}
