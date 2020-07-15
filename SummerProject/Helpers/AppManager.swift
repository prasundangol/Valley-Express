//
//  AppManager.swift
//  SummerProject
//
//  Created by MacBook Air on 7/12/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class AppManager{
    
    static let shared = AppManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerViewController!
    
    private init() { }
    
    func showApp(){
        var viewController: UIViewController
        
        if Auth.auth().currentUser == nil{
            viewController = storyboard.instantiateViewController(identifier: Constants.Stroyboard.loginViewController) 
        }
        else{
            viewController = storyboard.instantiateViewController(identifier: Constants.Stroyboard.itemViewController)
            
        }
        appContainer.present(viewController, animated: true, completion: nil)
        
    }
    
    func logout(){
        try! Auth.auth().signOut()
        appContainer.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}
