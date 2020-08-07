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
    
    var item: Model?
    let db = Firestore.firestore()
    let ref = Database.database().reference().child("cart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpElements()
    }
    
    func setUI(){
        
        titlelabel.text = item?.name
        
        descriptionView.text = item?.desc
        
        priceLabel.text = ("Rs. ") + (item?.price)!
        
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
        let user = Auth.auth().currentUser
        Utilities.styleFilledButton(orderNowButton)
        ref.child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in

        if snapshot.hasChild((self.item?.name)!){
            print("has item")
            Utilities.inCartButton(self.addToCartButton)
            
        }
        else{
            DispatchQueue.main.async {
                Utilities.styleFilledButton(self.addToCartButton)
            }
            
            }
        })
    }
    
    
    @IBAction func addToCartTapped(_ sender: Any) {
        sendToCart()
        Utilities.inCartButton(addToCartButton)
    }
    
    func sendToCart(){
        let user = Auth.auth().currentUser
        
                //Utilities.styleFilledButton(self.addToCartButton)
                        if let user = user{
                            let uid = user.uid
                    
                            let add = ["item": self.item?.name,
                                "desc":self.item?.desc,
                                "photo": self.item?.photo,
                                "price": self.item?.price]
                            
                            self.ref.child(uid).child((self.item?.name)!).setValue(add)

                }
        
   

        
    }
    

    
}

