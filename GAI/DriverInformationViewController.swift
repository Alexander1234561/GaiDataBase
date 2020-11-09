//
//  DriverInformationViewController.swift
//  GAI
//
//  Created by Александр on 06.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Bond

class DriverInformationViewController: UIViewController {

    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet weak var accidentsTableView: UITableView!
    
    var accidents = MutableObservableArray<AccidentObj>([])
    var cars = MutableObservableArray<CarObj>([])
    var driver: DriverObj?
    @IBOutlet var buttonsCategore: [UIButton]!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var idTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextfield.text = driver!.name
        self.surnameTextfield.text = driver!.surname
        self.idTextfield.text = String(driver!.id)
        
        
        accidents =  MutableObservableArray(myRealm.getAccidentsWithID(driverID: driver!.id))
        cars = MutableObservableArray(myRealm.getCarsWithID(driverID: driver!.id))
        
        cars.bind(to: carsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCel") as! CarsTableViewCell
            cell.carInfo.text = "\(self.cars[indexPath.row].mark) \(self.cars[indexPath.row].color)  id : \(self.cars[indexPath.row].id)"
            return cell
        }
        
        accidents.bind(to: accidentsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccidentCel") as! AccidentsTableViewCell
            cell.accidentInfo.text = "\(self.accidents[indexPath.row].driver!.surname) \(self.accidents[indexPath.row].fine)"
            return cell
        }
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        performSegue(withIdentifier: "ds", sender: nil)
    }
    
    @IBAction func addCarAction(_ sender: Any) {
        alertCarAction()
    }
    
    @IBAction func addAccidentAction(_ sender: Any) {
    }
    
    func alertCarAction(){
        
        let alert = UIAlertController(title: "Car", message: "Enter base information", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Mark"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "ID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Color"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            var category: carClass?
            if let cat = alert!.textFields![0].text, let mark = alert!.textFields![1].text, let id = alert!.textFields![2].text, let col = alert!.textFields![3].text{
                if cat == "A" {category = .A}
                if cat == "B" {category = .B}
                if cat == "C" {category = .C}
                if cat == "D" {category = .D}
                if let id = Int(id), let c = category{
                    let c = Car(driver: nil, id: id, category: c, color: col, mark: mark, year: 0, day: 0, month: .January, hours: 0)
                    myRealm.addCar(car: c, driverID: self.driver!.id)
                    self.cars.append(CarObj.getCarObject(car: c))
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
