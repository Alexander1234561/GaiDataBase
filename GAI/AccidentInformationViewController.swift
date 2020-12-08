//
//  AccidentInformationViewController.swift
//  GAI
//
//  Created by Александр on 08.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class AccidentInformationViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fineLabel: UILabel!
    @IBOutlet weak var driverID: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carID: UILabel!
    @IBOutlet weak var policemanID: UILabel!
    @IBOutlet weak var policemanName: UILabel!
    
    @IBOutlet weak var accidentImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage?{
        get{
            return accidentImage.image
        }
        set{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
            accidentImage.image = newValue
            accidentImage.sizeToFit()
        }
    }
    
    var accident: AccidentObj?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionLabel.text = accident!.descriptionAc
        self.fineLabel.text = String(accident!.fine)
        self.driverID.text = String(accident!.driver!.id)
        self.driverName.text = "\(accident!.driver!.name) \(accident!.driver!.surname)"
        self.carID.text = String(accident!.car!.id)
        self.policemanID.text = String(accident!.trafficCopID)
        self.policemanName.text = accident!.trafficCop
        self.dateLabel.text = "\(accident!.date!.day) : \(accident!.date!.month + 1) : \(accident!.date!.year)"
        
        fetchImage()
    }
    
    fileprivate func fetchImage() {
        
        imageURL = URL(string: "https://i3.guns.ru/forums/icons/forum_pictures/009683/9683803.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else{ return }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
