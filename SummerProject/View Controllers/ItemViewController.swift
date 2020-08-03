//
//  ItemViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/11/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemViewController: UIViewController {
    
    @IBOutlet weak var itemTable: UITableView!
    
    @IBAction func logOut(_ sender: Any) {
        
        loggedOut()
        
    }
    let data = [["adf","afdg","dfgd"],
                ["kkk","sss","tttt"],
                ["yyy","lll"]]
    var tots = [[Model]]()
    let data2 = ["ello","mate","fast"]
    var item = ItemListModel()
    var keys = String()
    var titleList = [String]()
    var itemList = [Model]()
    var ref = Database.database().reference().child("items")
    
    
    override func viewDidLoad() {
        setupNavigationBar()
        itemTable.delegate = self
        itemTable.dataSource = self
        
        //Space at the top before first section header
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 15))
//        itemTable.tableHeaderView = header
        
        getItems()        
    }
    
    //Seting up navigation bar
    private func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide" , size: 19)]
        navigationController?.navigationBar.titleTextAttributes = attribute as [NSAttributedString.Key : Any]
        
    }
    
    func getItems(){
        //Setting items in cell with section seperation
        ref.observe(.value) { (snap) in
            for child in snap.children{
                let data = child as! DataSnapshot
                self.keys = data.key
                self.titleList.append(self.keys)
                self.ref.child(self.keys).observe(DataEventType.value) { (snapshot) in
                     if snapshot.childrenCount > 0{
                        self.itemList.removeAll()
                         for items in snapshot.children.allObjects as![DataSnapshot]{
                             let itemObject = items.value as? [String: Any]
                             let itemName = itemObject?["item"]
                             let itemDesc = itemObject?["desc"]
                             let itemPhoto = itemObject?["photo"]
                             let item = Model(name: itemName as! String, photo: itemPhoto as! String, desc: itemDesc as! String)
                            self.itemList.append(item)
                         }
                        self.tots.append(self.itemList)
                        DispatchQueue.main.async {
                            self.itemTable.reloadData()
}
                     }
                     
                     
                 }
            }
        }
        
    }
    
    
    //Setting up logout button
    func loggedOut(){
        do {
                   try Auth.auth().signOut()
               }
            catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
               }
               
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let initial = storyboard.instantiateInitialViewController()
                self.view.window?.rootViewController = initial
                self.view.window?.makeKeyAndVisible()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Stroyboard.itemToDetailSegue{
            let destVC = segue.destination as! DetailViewController
            destVC.item = sender as? Model
            
        }
    }
        
    }


   

extension ItemViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tots.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tots[section].count
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].count
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Stroyboard.itemCell , for: indexPath) as! ItemTableViewCell
        let item: Model
        item = tots[indexPath.section][indexPath.row]
        cell.setCell(item)
        
        //cell.testLabel.text = data[indexPath.section][indexPath.row] (test ko lagi theeyo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var supp = String()
        for index in 0...section{
            supp = titleList[index]
        }
        return supp
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        var suppose = String()
//
//        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: itemTable.bounds.size.width, height: itemTable.bounds.size.height))
//        for index in 0...section{
//            suppose = titleList[index]
//        }
//        headerLabel.text = suppose
//        headerLabel.font = UIFont(name:"Verdana", size:20)
//        headerLabel.sizeToFit()
//        vw.addSubview(headerLabel)
//        vw.backgroundColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 0.7)
//
//        return vw
//    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let vw = UIView()
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 25)
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.textLabel?.textColor = UIColor.black
        vw.backgroundColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
        header.backgroundView = vw
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Model
        item = tots[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.Stroyboard.itemToDetailSegue, sender: item)
    }
    
    
    
}
        
    
    

