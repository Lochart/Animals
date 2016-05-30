//
//  Kinds.swift
//  NotebookAnimal
//
//  Created by Nikolay on 29.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import Foundation
import Firebase

class Kinds {
    let kind: String!
    
    init(snapshot: FDataSnapshot){
        self.kind = snapshot.value["kind"] as! String
    }
}