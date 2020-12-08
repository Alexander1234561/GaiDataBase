//
//  TabBar.swift
//  GAI
//
//  Created by Александр on 30.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    var delegateCar: CarDelegate?
    var delegateAcc: AccDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 {
            delegateCar?.update()
        }
        
        if item.tag == 2 {
            delegateAcc?.update()
        }
    }
}
