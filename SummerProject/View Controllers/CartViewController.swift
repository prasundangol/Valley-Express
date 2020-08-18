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
    
    
        var keys = String()
        var titleList = [String]()
        var itemList = [Model]()
        var ref = Database.database().reference().child("cart")
        let uid = Auth.auth().currentUser?.uid
        let detailController = DetailViewController()

        
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        cartTableView.delegate = self
        cartTableView.dataSource = self
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
                                let itemPrice = itemObject?["price"]
                                let item = Model(name: itemName as! String, photo: itemPhoto as! String, desc: itemDesc as! String, price: itemPrice as! String, quantity: "1")
                                self.itemList.append(item)
                             }
                            DispatchQueue.main.async {
                                self.cartTableView.reloadData()
                            }
                         }
                         
                         
                     }
                }
            
    //Moving data to view at detail view controller
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == Constants.Stroyboard.cartToDetailSegue{
                    let destVC = segue.destination as! DetailViewController
                    destVC.item = sender as? Model
                    
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Model
        item = itemList[indexPath.row]
        performSegue(withIdentifier: Constants.Stroyboard.cartToDetailSegue, sender: item)
    }
    
    
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
            
            cartTableView.endUpdates()
            


            
        }
        
            
    }
    
    
}
