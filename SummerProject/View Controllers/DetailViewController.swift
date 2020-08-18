//
//  DetailViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 8/2/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DetailViewController: UIViewController {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var orderNowButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UITextField!
    
    var item: Model?
    let db = Firestore.firestore()
    let ref = Database.database().reference().child("cart")
    let user = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpElements()
    }
    
    func setUI(){
        
        titlelabel.text = item?.name
        
        descriptionView.text = item?.desc
        
        priceLabel.text = ("Rs. ") + (item?.price)!
        
        quantityLabel.text = item?.quantity
        
        let url = URL(string: self.item!.photo!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                self.itemImage.image = image
            }
            
        }
        
        //Start the task
        dataTask.resume()
        
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(orderNowButton)
        ref.child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild((self.item?.name)!){
                //print("has item")
                Utilities.inCartButton(self.addToCartButton)
                
            }
            else{
                DispatchQueue.main.async {
                    Utilities.styleFilledButton(self.addToCartButton)
                }
                
            }
        })
    }
    
    //MARK: - Add To Cart
    
    @IBAction func addToCartTapped(_ sender: Any) {
        sendToCart()
        Utilities.inCartButton(addToCartButton)
    }
    
    func sendToCart(){
        //Utilities.styleFilledButton(self.addToCartButton)
        if let user = user{
            let uid = user.uid
            
            let add = ["item": self.item?.name,
                       "desc":self.item?.desc,
                       "photo": self.item?.photo,
                       "price": self.item?.price,
                       "quantity": quantityLabel.text]
            
            self.ref.child(uid).child((self.item?.name)!).setValue(add)
        }
        
        
        
        
    }
    
    //MARK: - Order
    
    @IBAction func orderTapped(_ sender: Any) {
        showAlert()
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Order", message: "How would you like to place the order?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cash on Delivery", style: .default, handler: { (action) in
            self.conformationAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Esewa", style: .default, handler: { (action) in
            print("Esewa")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func conformationAlert(){
        let confirmAlert = UIAlertController(title: "Confirm Your Order", message: "Once you click confirm order will be placed and it cannot be canceled", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            self.orderPlaced()
        }))
        
        DispatchQueue.main.async {
            self.present(confirmAlert, animated: true, completion: nil)
        }
    }
    
    func orderPlaced(){
        let orderRef = Database.database().reference().child("orders")
        
        if let user = user{
            let uid = user.uid
            
            let add = ["item": self.item!.name!,
                       "desc":self.item!.desc!,
                       "photo": self.item!.photo!,
                       "price": self.item!.price!,
                       "quantity": quantityLabel.text!,
                       "paymentMethod": "Cash on Delivery"] as [String : Any]
            
            orderRef.child(uid).child((self.item?.name)!).setValue(add)
            
            ref.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild((self.item?.name)!){
                    self.ref.child(uid).child((self.item?.name)!).removeValue()
                    
                    
                }
                
            })
            
        }
        postAlert(title: "Your order is on its way")
        
        
        
    }
    func postAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // delays execution of code to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
    }
    
}

