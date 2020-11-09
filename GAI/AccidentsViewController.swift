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

    @IBOutlet weak var carId: UITextField!
    @IBOutlet weak var driverId: UITextField!
    @IBOutlet weak var leftDate: UITextField!
    @IBOutlet weak var rightDate: UITextField!
    @IBOutlet weak var accidentsTableView: UITableView!
    
    var accidents = ObservableArray( myRealm.getAccidents() )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accidents.bind(to: accidentsTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccidentCell") as! AccidentsTableViewCell
            cell.accidentInfo.text = "\(self.accidents[indexPath.row].driver!.surname) \(self.accidents[indexPath.row].fine)"
            cell.accident = self.accidents[indexPath.row]
            return cell
        }
        
    }
    
    //Переход на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? AccidentInformationViewController, let cell = sender as? AccidentsTableViewCell {
           dvc.accident = cell.accident
        }
    }
    
    //Возварщение обратно к экрану
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        if segue.identifier == "dc3"{ }
    }
}
