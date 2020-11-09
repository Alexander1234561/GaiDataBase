//
//  CarsTableViewCell.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class CarsTableViewCell: UITableViewCell {
    @IBOutlet weak var carInfo: UILabel!
    
    var car: CarObj?
    
    func setCar(object: CarObj) {
        car = object
    }
}
