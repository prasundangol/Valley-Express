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
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UITextField!
    
    var item: Model?
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
        Utilities.styleFilledButton(addToCartButton)
        Utilities.styleHollowButton(cancelButton)
        
    }
    
    //MARK: - Add To Cart
    
    @IBAction func addToCartTapped(_ sender: Any) {
        sendToCart()
        
    }
    
    func sendToCart(){
        //Utilities.styleFilledButton(self.addToCartButton)
        if let user = user{
            let uid = user.uid
            let quantity = Int((quantityLabel.text)!)
            let price = Int((item?.price)!)
            let total = String(quantity! * price!)
            
            let add = ["item": (self.item?.name)!,
                       "desc":(self.item?.desc)!,
                       "photo": (self.item?.photo)!,
                       "price": total,
                       "quantity": quantityLabel.text!] as [String : Any]
            
            self.ref.child(uid).child((self.item?.name)!).setValue(add)
            postAlert(title: "Added to Cart")
            //self.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    //MARK: - Order
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func postAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // delays execution of code to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
    }
    
}

