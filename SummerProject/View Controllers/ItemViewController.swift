//
//  ItemViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/11/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class ItemViewController: UIViewController {
    
    @IBAction func logOut(_ sender: Any) {
        loggedOut()
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }
    
    func loggedOut(){
        do {
                   try Auth.auth().signOut()
               }
            catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
               }
               
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let initial = storyboard.instantiateInitialViewController()
                self.view.window?.rootViewController = initial
                self.view.window?.makeKeyAndVisible()
        }
        
    }
   
    
        
    
    

