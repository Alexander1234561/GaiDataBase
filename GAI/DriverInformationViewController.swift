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
    @IBOutlet weak var idTextfield: UILabel!
    @IBOutlet weak var catA: UIButton!
    @IBOutlet weak var catB: UIButton!
    @IBOutlet weak var catC: UIButton!
    @IBOutlet weak var catD: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextfield.text = driver!.name
        self.surnameTextfield.text = driver!.surname
        self.idTextfield.text = String(driver!.id)
        
        
        accidents =  MutableObservableArray(myRealm.getAccidentsWithID(driverID: driver!.id))
        cars = MutableObservableArray(myRealm.getCarsWithID(driverID: driver!.id))
        
        catA.backgroundColor = self.driver!.category.contains(0) ? UIColor.blue : UIColor.yellow
        catB.backgroundColor = self.driver!.category.contains(1) ? UIColor.blue : UIColor.yellow
        catC.backgroundColor = self.driver!.category.contains(2) ? UIColor.blue : UIColor.yellow
        catD.backgroundColor = self.driver!.category.contains(3) ? UIColor.blue : UIColor.yellow
        
        
        cars.bind(to: carsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCel") as! CarsTableViewCell
            cell.carInfo.text = "\(self.cars[indexPath.row].mark) id : \(self.cars[indexPath.row].id)"
            return cell
        }
        
        accidents.bind(to: accidentsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccidentCel") as! AccidentsTableViewCell
            cell.accidentInfo.text = "Driver id: \(self.idTextfield.text!) date: \(self.accidents[indexPath.row].date!.day):\(self.accidents[indexPath.row].date!.month + 1):\(self.accidents[indexPath.row].date!.year)"
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
        alertAccidentAction()
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
                    if (incorrectCarID(id: id)){
                        let c = Car(driver: nil, id: id, category: c, color: col, mark: mark, year: 0, day: 0, month: .January, hours: 0)
                        myRealm.addCar(car: c, driverID: self.driver!.id)
                        self.cars.append(CarObj.getCarObject(car: c))
                    }
                     else { DLog("Created Car Object: Error") }
                }
                else { DLog("Created Car Object: Error") }
            }
            else { DLog("Created Car Object: Error") }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func alertAccidentAction(){
        
        let alert = UIAlertController(title: "Accident", message: "Enter base information", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "CarID"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Fine"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Date"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "InspectorID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Inspector Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Inspector Surname"
        }
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            if let c = alert!.textFields![0].text, let des = alert!.textFields![1].text, let f = alert!.textFields![2].text, let d = alert!.textFields![3].text, let inID = alert!.textFields![4].text, let inName = alert!.textFields![5].text, let inSurname = alert!.textFields![6].text{
                if let c = Int(c),
                    let f = Int(f),
                    let d = changeDate(date: d),
                    let inID = Int(inID){
                    let t = TrafficCop(name: inName, surname: inSurname, id: inID)
                    let a = Accident(car: carClass(rawValue: (myRealm.getCarWithID(carID: c)?.category)!)!, carID: c, driverCat: self.driver?.category.map{carClass(rawValue: $0)!}, driverLS: (self.driver?.luxuryStatus)!, trafficCop: t, fine: f, year: d.year, day: d.day, month: d.month, hours: 0, description: des)
                    myRealm.addAccident(driverID: (self.driver?.id)!, carID: c, accident: a)
                    self.accidents.append(AccidentObj.getAccidentObject(accident: a))
                }
                else { DLog("Created Accident Object: Error") }
            }
            else { DLog("Created Accident Object: Error") }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func saveInformation(_ sender: Any) {
        do {
            try emptyFieldCheck(text: nameTextfield.text)
            try emptyFieldCheck(text: surnameTextfield.text)
            myRealm.changeDriverParam(name: nameTextfield.text!, surname: surnameTextfield.text!, driverID: self.driver!.id)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func categoryA(_ sender: UIButton) {
        if (sender.backgroundColor == UIColor.yellow){
            myRealm.addCategory(driverID: self.driver!.id, category: 0)
            sender.backgroundColor = UIColor.blue
        }
        else if (sender.backgroundColor == UIColor.blue){
            myRealm.removeCategory(driverID: self.driver!.id, category: 0)
            sender.backgroundColor = UIColor.yellow
        }
    }
    @IBAction func categoryB(_ sender: UIButton) {
        if (sender.backgroundColor == UIColor.yellow){
            myRealm.addCategory(driverID: self.driver!.id, category: 1)
            sender.backgroundColor = UIColor.blue
        }
        else if (sender.backgroundColor == UIColor.blue){
            myRealm.removeCategory(driverID: self.driver!.id, category: 1)
            sender.backgroundColor = UIColor.yellow
        }
    }
    @IBAction func categoryC(_ sender: UIButton) {
        if (sender.backgroundColor == UIColor.yellow){
            myRealm.addCategory(driverID: self.driver!.id, category: 2)
            sender.backgroundColor = UIColor.blue
        }
        else if (sender.backgroundColor == UIColor.blue){
            myRealm.removeCategory(driverID: self.driver!.id, category: 2)
            sender.backgroundColor = UIColor.yellow
        }
    }
    @IBAction func categoryD(_ sender: UIButton) {
        if (sender.backgroundColor == UIColor.yellow){
            myRealm.addCategory(driverID: self.driver!.id, category: 3)
            sender.backgroundColor = UIColor.blue
        }
        else if (sender.backgroundColor == UIColor.blue){
            myRealm.removeCategory(driverID: self.driver!.id, category: 3)
            sender.backgroundColor = UIColor.yellow
        }
    }
}
