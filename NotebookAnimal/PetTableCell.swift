//
//  CustomTableViewCell.swift
//  NotebookAnimal
//
//  Created by Nikolay on 21.05.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

import UIKit

class PetTableCell: UITableViewCell {

    @IBOutlet weak var namePetLabel: UILabel!
    @IBOutlet weak var kindOfAnimalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
