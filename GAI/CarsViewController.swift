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
    var cars = myRealm.getCars()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cars = myRealm.getCars()
        
        self.CarsTableView.delegate = self
        self.CarsTableView.reloadData()
    }
    
    //Переход на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CarInformationViewController, let cell = sender as? CarsTableViewCell {
            dvc.car = cell.car
        }
    }
    
    //Возварщение обратно к экрану
    @IBAction func carSeg(segue: UIStoryboardSegue) {
        if segue.identifier == "dc2"{ }
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        if carId.text != nil {
            if Int(carId.text!) != nil {
                self.cars.removeAll()
                for car in myRealm.getCars() {
                    if (car.id == Int(carId.text!)){
                        self.cars.append(car)
                        self.CarsTableView.reloadData()
                        } }
                return
            }
            
        }
        
        if driverId.text != nil {
            if Int(driverId.text!) != nil {
                self.cars.removeAll()
                for driver in myRealm.getDrivers() {
                    if (driver.id == Int(driverId.text!)){
                        self.cars = Array(driver.cars)
                        self.CarsTableView.reloadData()
                        } }
                return
            }
            
        }
        
        self.cars.removeAll()
        self.cars = myRealm.getCars()
        self.CarsTableView.reloadData()
    }
    
    @IBAction func savePDF(_ sender: Any) {
        let pdfFilePath = exportAsPdfFromTable(tb: self.CarsTableView, name: "Cars.pdf")
        print(pdfFilePath)
    }
    
}

extension CarsViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarsTableViewCell
        cell.carInfo.text = "\(self.cars[indexPath.row].mark) id: \(self.cars[indexPath.row].id)"
        cell.setCar(object: self.cars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            myRealm.removeCar(carID: self.cars.remove(at: indexPath.row).id)
            self.CarsTableView.reloadData()
        }
    }
}

protocol CarDelegate{
    func update()
}

extension CarsViewController: CarDelegate{
    func update() {
        self.cars = myRealm.getCars()
        self.CarsTableView.reloadData()
    }
}




