//
//  AccidentsTableViewCell.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class AccidentsTableViewCell: UITableViewCell {
    @IBOutlet weak var accidentInfo: UILabel!
    
    var accident: AccidentObj?
    
    func setCar(object: AccidentObj) {
        accident = object
    }
}
