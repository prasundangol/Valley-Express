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
    var tots = [[Model]]()
    
    
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
            }
            self.orderTableView.reloadData()
            self.activityIndicator.stopAnimating()
            
        }        
    }
    //Moving data for detail order view ie CartViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Stroyboard.orderToOrderList{
            let destVC = segue.destination as! CartViewController
            //destVC.itemList = (sender as? [Model])!
            destVC.keys = sender as! String
            destVC.segueDetect = 1
        }
    }
    
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let item: String
        orderTableView.deselectRow(at: indexPath, animated: true)
        item = titleList[indexPath.row]
        performSegue(withIdentifier: Constants.Stroyboard.orderToOrderList, sender: item)
        
    }
    
    
}
