//
//  AccidentsViewController.swift
//  GAI
//
//  Created by Александр on 19.10.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Bond

class AccidentsViewController: UIViewController {

    @IBOutlet weak var leftDate: UITextField!
    @IBOutlet weak var rightDate: UITextField!
    @IBOutlet weak var accidentsTableView: UITableView!
    
    var accidents = myRealm.getAccidents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accidentsTableView.delegate = self
        self.accidentsTableView.reloadData()
    }
    
    //Переход на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? AccidentInformationViewController, let cell = sender as? AccidentsTableViewCell {
           dvc.accident = cell.accident
        }
        if let dvc2 = segue.destination as? TabBar {
           dvc2.delegateAcc = self
        }
    }
    
    //Возварщение обратно к экрану
    @IBAction func accidentSeg(segue: UIStoryboardSegue) {
        if segue.identifier == "dc3"{ }
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        var flag1: Bool = false
        var flag2: Bool = false
        
        if let ld = leftDate.text {
            if changeDate(date: ld) != nil { flag1 = true }
        }
        
        if let rd = rightDate.text {
            if changeDate(date: rd) != nil { flag2 = true }
        }
        
        if (flag1 && flag2) {
            self.accidents.removeAll()
            for a in myRealm.getAccidents(){
                let d = Date(year: a.date!.year, month: Month(rawValue: a.date!.month)!, day: a.date!.day)
                if d >= changeDate(date: leftDate.text!)! && d <= changeDate(date: rightDate.text!)! { self.accidents.append(a); print("1") }
            }
            self.accidentsTableView.reloadData()
            return
        }
        
        if (flag1 && !flag2) {
            self.accidents.removeAll()
            for a in myRealm.getAccidents(){
                let d = Date(year: a.date!.year, month: Month(rawValue: a.date!.month)!, day: a.date!.day)
                if d >= changeDate(date: leftDate.text!)! { self.accidents.append(a); print("2") }
            }
            self.accidentsTableView.reloadData()
            return
        }
        
        if (!flag1 && flag2) {
            print("3")
            self.accidents.removeAll()
            for a in myRealm.getAccidents(){
                let d = Date(year: a.date!.year, month: Month(rawValue: a.date!.month)!, day: a.date!.day)
                if d <= changeDate(date: rightDate.text!)! { self.accidents.append(a); print("3") }
            }
            self.accidentsTableView.reloadData()
            return
        }
        
        if (!flag1 && !flag2) {
            print("4")
            self.accidents.removeAll()
            self.accidents = myRealm.getAccidents()
            self.accidentsTableView.reloadData()
        }
    }
    
    @IBAction func savePDF(_ sender: Any) {
        let pdfFilePath = exportAsPdfFromTable(tb: self.accidentsTableView, name: "Accidents.pdf")
        print(pdfFilePath)
    }
}

extension AccidentsViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccidentCell") as! AccidentsTableViewCell
        cell.accidentInfo.text = "DriverID: \(self.accidents[indexPath.row].driver!.id) carID: \(self.accidents[indexPath.row].car!.id) date: \(self.accidents[indexPath.row].date!.day):\(self.accidents[indexPath.row].date!.month + 1):\(self.accidents[indexPath.row].date!.year)"
        cell.accident = self.accidents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            myRealm.removeAccident(driverID:  self.accidents[indexPath.row].driver!.id, carID: self.accidents[indexPath.row].car!.id, date: self.accidents[indexPath.row].date!)
            self.accidents.remove(at: indexPath.row)
            self.accidentsTableView.reloadData()
        }
    }
}

protocol AccDelegate{
    func update()
}

extension AccidentsViewController: AccDelegate{
    func update() {
        print("Accident")
        self.accidents = myRealm.getAccidents()
        self.accidentsTableView.reloadData()
    }
}
