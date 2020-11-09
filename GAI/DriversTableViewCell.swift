//
//  DriversTableViewCell.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class DriversTableViewCell: UITableViewCell {
    @IBOutlet weak var driverInformation: UILabel!
    var driver: DriverObj?
    
    func setDriver(object: DriverObj) {
        driver = object
    }
}
