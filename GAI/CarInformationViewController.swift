//
//  CarInformationViewController.swift
//  GAI
//
//  Created by Александр on 08.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Bond

class CarInformationViewController: UIViewController {

    @IBOutlet weak var driverID: UITextField!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var carID: UITextField!
    @IBOutlet weak var technicalInspection: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var mark: UITextField!
    @IBOutlet weak var color: UITextField!
    @IBOutlet weak var accidentsOfCar: UITableView!
    
    var car: CarObj?
    var accidents = MutableObservableArray<AccidentObj>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.carID.text = String(car!.id)
        self.color.text = car!.color
        self.mark.text = car!.mark
        self.technicalInspection.text = "\(car!.techInsp!.day) : \(car!.techInsp!.month) : \(car!.techInsp!.year)"
        self.driverID.text = String(car!.owner!.id)
        self.driverName.text = "\(car!.owner!.name) \(car!.owner!.surname)"
        accidents = MutableObservableArray( myRealm.getAccidentsWithID(carID: car!.id) )
        
    accidents.bind(to: accidentsOfCar) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarAccidentCell") as! AccidentsTableViewCell
            cell.accidentInfo.text = "\(self.accidents[indexPath.row].driver!.surname) \(self.accidents[indexPath.row].fine)"
            return cell
        }
    }
    
}
