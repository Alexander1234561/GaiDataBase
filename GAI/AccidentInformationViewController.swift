//
//  AccidentInformationViewController.swift
//  GAI
//
//  Created by Александр on 08.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class AccidentInformationViewController: UIViewController {

    @IBOutlet weak var descripLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var fineLabel: UITextField!
    @IBOutlet weak var driverID: UITextField!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var carID: UITextField!
    @IBOutlet weak var policemanID: UITextField!
    @IBOutlet weak var policemanName: UITextField!
    
    var accident: AccidentObj?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fineLabel.text = String(accident!.fine)
        self.driverID.text = String(accident!.driver!.id)
        self.driverName.text = "\(accident!.driver!.name) \(accident!.driver!.surname)"
        self.carID.text = String(accident!.car!.id)
        self.policemanName.text = accident!.trafficCop
        self.dateLabel.text = "\(accident!.date!.day) : \(accident!.date!.month) : \(accident!.date!.year)"
    }
}
