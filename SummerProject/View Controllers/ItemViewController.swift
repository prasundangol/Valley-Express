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
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium" , size: 19)]
        navigationController?.navigationBar.titleTextAttributes = attribute as [NSAttributedString.Key : Any]
        
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
   
    
        
    
    

