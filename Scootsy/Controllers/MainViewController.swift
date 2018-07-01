//
//  MainViewController.swift
//  Scootsy
//
//  Created by Ashvarya Singh on 29/06/18.
//  Copyright © 2018 Ashvaray. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)
    }
    
}
