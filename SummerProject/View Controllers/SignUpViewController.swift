//
//  SignUpViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/11/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var phnoTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setupNavigationBar()
        
    }
    
    func setUpElements() {
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Styling the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(locationTextField)
        Utilities.styleTextField(phnoTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    //Check if everything is validated. Return nil of ok else return error message.
    func validateFields() -> String? {
        //Check that all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phnoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Please fill all fields"
        }
        
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            //Password isn't secure enough
            return "Please make sure your passowrd is 8 charachers, contains a special character and a number"
            
        }
        
        else if Utilities.isValidEmail(cleanedEmail) == false{
            return "Email is not valid"
            
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        //Validate the Fields
        let error = validateFields()
        
        if error != nil {
            //There was an error, show error message
            showError(error!)
        }
        else{
            //Create cleaned versions of data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phno = phnoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for erros
                if err != nil{
                    //There was an error
                    self.showError("The user already exits")
                      
                }
                else{
                    //User was corrected successfully and store data
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstname,"lastname":lastname,"location": location,"phno":phno,"uid": result!.user.uid]) { (error) in
                        if error != nil{
                            //Show error message
                            self.showError("Error while saving data")
                            
                        }
                    }
                    
                    //Transition to the home screen
                    self.transitionToItems()
                    
                }
            }
            
            
        }
        
        
    }
    
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    private func setupNavigationBar(){
           navigationController?.setNavigationBarHidden(false, animated: true)
           navigationController?.navigationBar.barTintColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
            navigationController?.navigationBar.tintColor = .white
    }
    
    func transitionToItems(){
        
        let itemViewController = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.itemViewController) as! ItemViewController
        self.navigationController?.pushViewController(itemViewController, animated: false)
        view.window?.makeKeyAndVisible()
        
    }
    
}
