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
        
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Color"
        }
        
        alert.addTextField { (textField) in
            textField.text = "Mark"
        }
        
        alert.addTextField { (textField) in
            textField.text = "ID"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if (alert!.textFields![0].text != nil && alert!.textFields![1].text != nil &&  alert!.textFields![2].text != nil){
                if (Int(alert!.textFields![2].text!) != nil){
                    let c = Car(driver: nil, id: Int(alert!.textFields![2].text!)!, category: .A, color: alert!.textFields![0].text!, mark: alert!.textFields![1].text!, year: 23, day: 23, month: .May, hours: 2)
                    myRealm.addCar(car: c, driverID: self.driver!.id)
                    self.cars.append(getCarObject(car: c))
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
