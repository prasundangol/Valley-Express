//
//  CartViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 8/3/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CartViewController: UIViewController {
    
    

    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    @IBOutlet weak var vatPriceLabel: UILabel!
    
    @IBOutlet weak var grandTotalPriceLabel: UILabel!
    
    @IBOutlet weak var checkOutButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keys = String()
        var titleList = [String]()
        var itemList = [Model]()
        var ref = Database.database().reference().child("cart")
        let uid = Auth.auth().currentUser?.uid
        let detailController = DetailViewController()
        var priceList = [String]()
        var value = 0
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        getItems()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        setTotal()
        
    }
    

        func getItems(){
            //Setting items in cell with section seperation
                    ref.child(uid!).observe(DataEventType.value) { (snapshot) in
                         if snapshot.childrenCount > 0{
                            self.itemList.removeAll()
                             for items in snapshot.children.allObjects as![DataSnapshot]{
                                 let itemObject = items.value as? [String: Any]
                                 let itemName = itemObject?["item"]
                                 let itemDesc = itemObject?["desc"]
                                 let itemPhoto = itemObject?["photo"]
                                let itemPrice = itemObject?["price"] as! String
                                let itemQuantity = itemObject?["quantity"]
                                let item = Model(name: itemName as! String, photo: itemPhoto as! String , desc: itemDesc as! String, price: itemPrice , quantity: itemQuantity as! String)
                                self.itemList.append(item)
                                self.priceList.append(itemPrice)
                             }
                            DispatchQueue.main.async {
                                self.cartTableView.reloadData()
                            }

                         }
                        self.activityIndicator.stopAnimating()
                     }
                }
    
    func setTotal(){
        ref.child(uid!).observe(DataEventType.value) { (snapshot) in
            if self.itemList.count == 0{
                self.checkOutButton.isEnabled = false
                   }
                   else{
                self.checkOutButton.isEnabled = true
                   }
            guard self.itemList.count != 0 else {
                self.subTotalLabel.text = "Rs. 0"
                self.vatPriceLabel.text = "Rs. 0"
                self.grandTotalPriceLabel.text = "Rs. 0"
                return
            }
            
            for index in 0...self.priceList.count-1{
                self.value = self.value + Int(self.priceList[index])!
                
            }
            self.subTotalLabel.text = ("Rs. ") + String(self.value)
            let vat = round(Float(13/100 * Float(self.value)))
            self.vatPriceLabel.text = ("Rs. ") + String(vat)
            let grandTotal = self.value + Int(vat)
            self.grandTotalPriceLabel.text = ("Rs. ") + String(grandTotal)

        }
    }
            
    //Moving data to view at detail view controller
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == Constants.Stroyboard.cartToDetailSegue{
                    let destVC = segue.destination as! DetailViewController
                    destVC.item = sender as? Model
                    
                }
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
        
        if let user = uid{
            let uid = user
            
            for index in 0...itemList.count - 1 {
                let add = ["item": itemList[index].name!,
                "desc":itemList[index].desc!,
                "photo": itemList[index].photo!,
                "price": itemList[index].price!,
                "quantity": itemList[index].quantity!,
                "paymentMethod": "Cash on Delivery"] as [String : Any]
                orderRef.child(uid).child(Utilities.getDate()).child(itemList[index].name!).setValue(add)
                
                
            }
            
            
            
//            ref.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if snapshot.hasChild((self.item?.name)!){
//                    self.ref.child(uid).child((self.item?.name)!).removeValue()
//
//
//                }
//
//            })
            
        }
        postAlert(title: "Your order is on its way")
        
        
        
    }
    func postAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let instanceVC = storyboard?.instantiateViewController(identifier: Constants.Stroyboard.itemViewController) as! ItemViewController
        
        self.present(alert, animated: true, completion: nil)
        
        // delays execution of code to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            alert.dismiss(animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(instanceVC, animated: true)
            self.view.window?.makeKeyAndVisible()
            
        })
    }
    
    @IBAction func checkOutTapped(_ sender: Any) {
        showAlert()
    }
    
    
        }



extension CartViewController: UITableViewDelegate,UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: Constants.Stroyboard.cartCell, for: indexPath) as! CartTableViewCell
        let item: Model
        item = itemList[indexPath.row]
        cell.cartCell(item)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item: Model
//        item = itemList[indexPath.row]
//        performSegue(withIdentifier: Constants.Stroyboard.cartToDetailSegue, sender: item)
//        cartTableView.deselectRow(at: indexPath, animated: true)
//    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            //Removing the item from firebase database
            let item: Model?
            item = itemList[indexPath.row]
            
            ref.child(uid!).child((item?.name)!).removeValue()
            
            cartTableView.beginUpdates()
            itemList.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath] , with: .right)
            priceList.removeAll()
            self.value = 0
            
            cartTableView.endUpdates()
            


            
        }
        
            
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
}
