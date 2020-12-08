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


    @IBOutlet weak var technicalInspection: UITextField!
    @IBOutlet weak var color: UITextField!
    @IBOutlet weak var driverID: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carID: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    @IBOutlet weak var accidentsOfCar: UITableView!
    
    var car: CarObj?
    var accidents = MutableObservableArray<AccidentObj>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.carID.text = String(car!.id)
        self.color.text = car!.color
        self.mark.text = car!.mark
        self.technicalInspection.text = "\(car!.techInsp!.day) : \(car!.techInsp!.month + 1) : \(car!.techInsp!.year)"
        self.driverID.text = String(car!.owner!.id)
        self.driverName.text = "\(car!.owner!.name) \(car!.owner!.surname)"
        self.category.text = String(car!.category)
        accidents = MutableObservableArray( myRealm.getAccidentsWithID(carID: car!.id) )
        
    accidents.bind(to: accidentsOfCar) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarAccidentCell") as! AccidentsTableViewCell
        cell.accidentInfo.text = "Driver id: \(self.driverID.text!) date: \(self.accidents[indexPath.row].date!.day):\(self.accidents[indexPath.row].date!.month + 1):\(self.accidents[indexPath.row].date!.year)"
            return cell
        }
    }
    @IBAction func saveAction(_ sender: Any) {
        do {
            try emptyFieldCheck(text: color.text)
            try emptyFieldCheck(text: technicalInspection.text)
             myRealm.changeCarParamColor(color: color.text!, carID: self.car!.id)
            
            if let tp = changeDate(date: technicalInspection.text!) {
                myRealm.changeCarParamColor(color: color.text!, carID: self.car!.id)
                myRealm.changeCarParamTechInsp(date: tp, carID: self.car!.id)
            } else {
                throw MyError.incorrectField
            }
        }
        catch{
            //print(error.localizedDescription)
        }
    }
}
