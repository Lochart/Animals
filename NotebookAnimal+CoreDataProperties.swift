//
//  NotebookAnimal+CoreDataProperties.swift
//  NotebookAnimal
//
//  Created by Nikolay on 25.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NotebookAnimal {

    @NSManaged var kindOfPet: String?
    @NSManaged var namePet: String?
    @NSManaged var kinds: NSSet?

}
