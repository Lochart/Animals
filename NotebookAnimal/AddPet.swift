//
//  ViewController.swift
//  NotebookAnimal
//
//  Created by Nikolay on 20.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AddPet: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate  {
    //*** Этот класс мы полностью настроили на запись/ввод введенной информации. *** Первым делом добавим аутлеты для всех объектов взаимодействия
    
    @IBOutlet weak var labelKindOfAnimal: UILabel!
    @IBOutlet weak var namePetTextField: UITextField!
    
    @IBOutlet weak var kindTableView: UITableView!
    
    let firebasePet = Firebase(url:"https://notebookanimals-umbrella.firebaseio.com/pet")
    let firebaseKind = Firebase(url:"https://notebookanimals-umbrella.firebaseio.com/kind")
    
    let tableIdentifier = "CellKind"
    
    var notebookAnimal: NotebookAnimal!
    var kindAnimal: KindOfAnimal!
    var kindOfAnimals = [KindOfAnimal]()
    
    var fetchResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFireBaseKind()

        let fetchRequest = NSFetchRequest(entityName: "KindOfAnimal")
        let sortDescriptor = NSSortDescriptor(key: "kind", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = nil
            
            do {
                try fetchResultController.performFetch()
                kindOfAnimals = fetchResultController.fetchedObjects as! [KindOfAnimal]
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchResultController.delegate = self
        kindTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
    super.viewWillDisappear(animated)
    self.fetchResultController.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init (coder aDecoder:(NSCoder!)){
        super.init(coder:aDecoder)!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView!,
                   cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:tableIdentifier)
        
        let kindOfAnimal = fetchResultController.objectAtIndexPath(indexPath)
        
        cell.textLabel?.text = kindOfAnimal.kind
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let path = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(path!)
        
        labelKindOfAnimal.text = cell!.textLabel?.text
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        kindTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            kindTableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            kindTableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
        if let indexPath = newIndexPath {
            kindTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        break;
        case .Delete:
        if let indexPath = indexPath {
            kindTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        break;
        case .Update:
        if let indexPath = indexPath {
            kindTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        break;
        case .Move:
        if let indexPath = indexPath {
            kindTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        if let newIndexPath = newIndexPath {
            kindTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        }
        break;
    }

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        kindTableView.endUpdates()
    }
    
    
    @IBAction func save(sender: UIBarButtonItem) {
        let namePet = namePetTextField.text
        let kindOfAnimal = labelKindOfAnimal.text
        
        let newPet: NSDictionary = ["namePet": namePet!, "kindOfAnimal": kindOfAnimal!]
        
        let filePet = firebasePet.ref.childByAppendingPath(namePet!)
        filePet.setValue(newPet)
        
        // Проверка на введенных строк
        if namePet == "" {
            let alertController = UIAlertController(title: "Ошибка", message: "Убедитесь что все поля заполнены.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            notebookAnimal = NSEntityDescription.insertNewObjectForEntityForName("NotebookAnimal", inManagedObjectContext: managedObjectContext) as! NotebookAnimal
            
            notebookAnimal.namePet = namePet!
            notebookAnimal.kindOfPet = kindOfAnimal!
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
                return
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadDataFireBaseKind(){
        
        firebaseKind.observeEventType(FEventType.Value, withBlock: { [weak self] (snapshot) in
            self?.deleteAllData("KindOfAnimal")
            
            for list in snapshot.children {
                let kindList = Kinds(snapshot: list as! FDataSnapshot)
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    
                    self?.kindAnimal = NSEntityDescription.insertNewObjectForEntityForName("KindOfAnimal", inManagedObjectContext: managedObjectContext) as! KindOfAnimal
                    
                    self?.kindAnimal.kind = kindList.kind;
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                        return
                    }
                }
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    deinit{
        NSLog("deinit %p", self)
        fetchResultController.delegate = nil
    }
    
}

