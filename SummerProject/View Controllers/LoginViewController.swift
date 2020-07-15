//
//  LoginViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/11/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
    }
    override func viewDidAppear(_ animated: Bool){
     super.viewDidAppear(animated)
     if Auth.auth().currentUser != nil {
        self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
    }
    }
    
    func setUpElements(){
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
        
        
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        //Validate text fields
        
        //Cleaned versions of the textfield
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                //Couldn't sign in
                self.errorLabel.text = "Incorrect Password"
                self.errorLabel.alpha = 1
                
            }
            else{
                let itemViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroyboard.itemViewController) as! ItemViewController
                self.view.window?.rootViewController = itemViewController
                self.view.window?.makeKeyAndVisible()
            }
            
        }
        
    }
    
    
    
    
}
