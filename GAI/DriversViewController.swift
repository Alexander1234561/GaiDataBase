//
//  DriversViewController.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Bond

class DriversViewController: UIViewController{

    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverSurname: UITextField!
    @IBOutlet weak var driverId: UITextField!
    @IBOutlet weak var driverCountry: UITextField!
    @IBOutlet weak var driverCity: UITextField!
    @IBOutlet weak var driversTableView: UITableView!
    
    var drivers = MutableObservableArray( myRealm.getDrivers() )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBind()
    }
    
    //Создание алерта для заполнения данных
    func alertAction(){
        
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Name"
        }
        
        alert.addTextField { (textField) in
            textField.text = "Surname"
        }
        
        alert.addTextField { (textField) in
            textField.text = "ID"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if (alert!.textFields![0].text != nil && alert!.textFields![1].text != nil &&  alert!.textFields![2].text != nil){
                if (Int(alert!.textFields![2].text!) != nil){
                    let d = Driver(category: [], cars: [], accidents: [], name: alert!.textFields![0].text!, surname: alert!.textFields![0].text!, id: Int(alert!.textFields![2].text!)!, lStatus: true)
                    myRealm.addDriver(driver: d)
                    self.drivers.append(getDriverObject(driver: d))
                }
            }
        }))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    //Вызов алерта
    @IBAction func addAction(_ sender: Any) {
        alertAction()
    }
    
    //Переход на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DriverInformationViewController, let cell = sender as? DriversTableViewCell {
            dvc.driver = cell.driver
        }
    }
    
    //Возвращение обратно к экрану
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        if segue.identifier == "ds"{}
    }
    
    //Фильтрация
    @IBAction func filterAction(_ sender: Any) {
        
        var mass: [DriverObj] = []
        var flag1: Bool = false
        var flag2: Bool = false
        
        if driverName.text != "" { flag1 = true }
        if driverSurname.text != "" { flag2 = true }
        if driverId.text != nil {
            if Int(driverId.text!) != nil {
                self.drivers.removeAll()
                for driver in myRealm.getDrivers() {
                    if (driver.id == Int(driverId.text!)){
                        self.drivers.append(driver)
                        return } } }
            
        }
        if (flag1 && flag2) {
            self.drivers.removeAll()
            for driver in myRealm.getDrivers() {
                if (driver.name == driverName.text! && driver.surname == driverSurname.text!) {
                    mass.append(driver)
                }
            }
            self.drivers = MutableObservableArray(mass)
            myBind()
            return
        }
        
        if (!flag1 && flag2) {
            self.drivers.removeAll()
            for driver in myRealm.getDrivers() {
                if (driver.surname == driverSurname.text!) {
                    mass.append(driver)
                }
            }
            self.drivers = MutableObservableArray(mass)
            myBind()
            return
        }
        
        if (flag1 && !flag2) {
            self.drivers.removeAll()
            for driver in myRealm.getDrivers() {
                if (driver.name == driverName.text!) {
                    mass.append(driver)
                }
            }
            self.drivers = MutableObservableArray(mass)
            myBind()
            return
        }
        
        if (!flag1 && !flag2) {
            self.drivers.removeAll()
            self.drivers = MutableObservableArray(myRealm.getDrivers())
            myBind()
        }
    }
    
    func myBind() {
        self.drivers.bind(to: driversTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell") as! DriversTableViewCell
            cell.driverInformation.text = "\(self.drivers[indexPath.row].name) \(self.drivers[indexPath.row].surname)    id: \(self.drivers[indexPath.row].id)"
            cell.setDriver(object: self.drivers[indexPath.row])
            return cell
        }
    }
}
