//
//  CarsViewController.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Bond

class CarsViewController: UIViewController {

    @IBOutlet weak var carId: UITextField!
    @IBOutlet weak var driverId: UITextField!
    
    @IBOutlet weak var CarsTableView: UITableView!
    var cars = MutableObservableArray( myRealm.getCars() )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cars = MutableObservableArray( myRealm.getCars() )
        
        myBind()
    }
    
    //Переход на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CarInformationViewController, let cell = sender as? CarsTableViewCell {
            dvc.car = cell.car
        }
    }
    
    //Возварщение обратно к экрану
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        if segue.identifier == "dc2"{ }
    }
    @IBAction func filterAction(_ sender: Any) {
        
        if carId.text != nil {
            if Int(carId.text!) != nil {
                self.cars.removeAll()
                for car in myRealm.getCars() {
                    if (car.id == Int(carId.text!)){
                        self.cars.append(car)
                        return } } }
            
        }
        
        if driverId.text != nil {
            if Int(driverId.text!) != nil {
                self.cars.removeAll()
                for driver in myRealm.getDrivers() {
                    if (driver.id == Int(driverId.text!)){
                        self.cars = MutableObservableArray( Array(driver.cars) )
                        myBind()
                        return } } }
            
        }
        self.cars.removeAll()
        self.cars = MutableObservableArray(myRealm.getCars())
        myBind()
    }
    
    func myBind(){
        cars.bind(to: CarsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarsTableViewCell
            cell.carInfo.text = "\(self.cars[indexPath.row].mark) \(self.cars[indexPath.row].color) with id : \(self.cars[indexPath.row].id)"
            cell.setCar(object: self.cars[indexPath.row])
            return cell
        }
    }
    
}

