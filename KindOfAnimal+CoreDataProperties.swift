//
//  KindOfAnimal+CoreDataProperties.swift
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

extension KindOfAnimal {

    @NSManaged var kind: String?
    @NSManaged var notebookAnimal: NotebookAnimal?

}
