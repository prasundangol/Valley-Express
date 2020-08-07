//
//  ItemListModel.swift
//  SummerProject
//
//  Created by MacBook Air on 7/23/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class ItemListModel{
     static var itemList = [Model]()
    var ref = Database.database().reference().child("items")
    
    
    func getitems(){
        ref.child("momo").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0{
                ItemListModel.itemList.removeAll()
                for items in snapshot.children.allObjects as![DataSnapshot]{
                    let itemObject = items.value as? [String: Any]
                    let itemName = itemObject?["item"]
                    let itemDesc = itemObject?["desc"]
                    let itemPhoto = itemObject?["photo"]
                    let itemPrice = itemObject?["price"]
                    let item = Model(name: itemName as! String, photo: itemPhoto as! String, desc: itemDesc as! String, price: itemPrice as! String)
                    ItemListModel.itemList.append(item)
                }
            }
        }

    }
    
}
