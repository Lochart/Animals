//
//  iCloudNotebookPetTablewViewControllerTableViewController.swift
//  NotebookAnimal
//
//  Created by Nikolay on 21.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import UIKit
import Firebase

class FireBasePetTable: UITableViewController {
    //*** Этот класс выводит информацию из iCloud в которй содержит базу животных, которые добавляли

    @IBOutlet var spinner: UIActivityIndicatorView!

    
    let firebasePet = Firebase(url:"https://notebookanimals-umbrella.firebaseio.com/pet")    
    
    var notebookAnimals = [Pets]()
    
    let tableIdentifier = "PetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFireBase()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(tableIdentifier, forIndexPath: indexPath) as! FireBasePetTableCell

        let notebookAnimal = notebookAnimals[indexPath.row]
        
        cell.namePetLabel.text = notebookAnimal.namePet
        cell.kindOfAnimalLabel.text = notebookAnimal.kindOfAnimal

        return cell
    }
    
    func loadDataFireBase(){
        
        firebasePet.observeEventType(FEventType.Value, withBlock: { (snapshot) in
            
            var newPet = [Pets]()
            
            let connected = snapshot.value as? Bool
            
            if connected != nil {

                    let alertController = UIAlertController(title: "Ошибка", message: "Не удалось получить данные из облачного сервера.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
            } else {
                for list  in snapshot.children{
                    let petList = Pets(snapshot: list as! FDataSnapshot)
                    newPet.append(petList)
                    
                    self.notebookAnimals = newPet
                    self.tableView.reloadData()
                }
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
    }

}
