//
//  AppContainerViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/12/20.
//  Copyright © 2020 MacBook Air. All rights reserved.

import UIKit

class AppContainerViewController: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
        
        
    }
    
}
