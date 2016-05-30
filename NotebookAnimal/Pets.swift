//
//  Pets.swift
//  NotebookAnimal
//
//  Created by Nikolay on 28.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import Foundation
import Firebase

class Pets {
    let namePet: String!
    let kindOfAnimal: String!
    
    init(snapshot: FDataSnapshot){
        self.namePet = snapshot.value["namePet"] as! String
        self.kindOfAnimal = snapshot.value["kindOfAnimal"] as! String
    }
}