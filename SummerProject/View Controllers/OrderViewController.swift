//
//  OrderViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 8/22/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class OrderViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var ref = Database.database().reference().child("orders")
    var user = Auth.auth().currentUser?.uid
    var keys = String()
    var titleList = [String]()
    var itemKeys = String()
    var itemList = [Model]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        orderTableView.delegate = self
        orderTableView.dataSource = self
        getItems()
        
    }
    
    
    func getItems(){
        guard user != nil else{
            return
        }
        
        self.ref.child(user!).observe(.value) { (snap) in
            for child in snap.children{
                let data = child as! DataSnapshot
                self.keys = data.key
                self.titleList.append(self.keys)
                self.ref.child(self.user!).child(self.keys).observe(.value) { (snaps) in
                        self.ref.child(self.user!).child(self.keys).observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0{
                                self.itemList.removeAll()
                                for items in snapshot.children.allObjects as![DataSnapshot]{
                                    let itemObject = items.value as? [String: AnyObject]
                                    let itemName = itemObject?["item"] as! String
                                    let itemDesc = itemObject?["desc"] as! String
                                    let itemPhoto = itemObject?["photo"] as! String
                                    let itemPrice = itemObject?["price"] as! String
                                    let itemQuantity = itemObject?["quantity"] as! String
                                    let item = Model(name: itemName, photo: itemPhoto, desc: itemDesc, price: itemPrice, quantity: itemQuantity)
                                    self.itemList.append(item)
                                }
                                print("tsk\(self.itemList)")
                            }
                            DispatchQueue.main.async {
                                self.orderTableView.reloadData()
                            }
                            
                            
                        }
                    
                }
            }
            self.activityIndicator.stopAnimating()

        }        
    }
    //Moving data for detail order view ie CartViewController

    
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("haha\(titleList.count)")
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: Constants.Stroyboard.orderCell, for: indexPath) as! OrderTableViewCell
        let item: String?
        item = titleList[indexPath.row]
        cell.setCell(item: item!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
