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
import SideMenu

class ItemViewController: UIViewController, MenuControllerDelegate  {
    
    
    
    @IBOutlet weak var itemTable: UITableView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func didTappedSideMenu(_ sender: Any) {
        
        present(sideMenu!,animated: true)
        
    }
    
    private var sideMenu: SideMenuNavigationController?
    var tots = [[Model]]()
    var keys = String()
    var titleList = [String]()
    var itemList = [Model]()
    var ref = Database.database().reference().child("items")
    
    
    
    override func viewDidLoad() {
        let menu = SideMenuTableViewController(with: ["Menu","Cart","Search","My Orders","Logout"])
        sideMenu = SideMenuNavigationController (rootViewController: menu)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        setupNavigationBar()
        itemTable.delegate = self
        itemTable.dataSource = self
        menu.delegate = self
        getItems()
        
        //Side Menu setup
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
    }
    
    //Seting up navigation bar
    private func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide" , size: 19)]
        navigationController?.navigationBar.titleTextAttributes = attribute as [NSAttributedString.Key : Any]
        
    }
    
    func getItems(){
        DispatchQueue.global(qos: .userInteractive).async{
            //Setting items in cell with section seperation
            self.ref.observe(.value) { (snap) in
                for child in snap.children{
                    let data = child as! DataSnapshot
                    self.keys = data.key
                    self.titleList.append(self.keys)
                    self.ref.child(self.keys).observe(DataEventType.value) { (snapshot) in
                        if snapshot.childrenCount > 0{
                            self.itemList.removeAll()
                            for items in snapshot.children.allObjects as![DataSnapshot]{
                                let itemObject = items.value as? [String: AnyObject]
                                let itemName = itemObject?["item"]
                                let itemDesc = itemObject?["desc"]
                                let itemPhoto = itemObject?["photo"]
                                let itemPrice = itemObject?["price"]
                                let item = Model(name: itemName as? String, photo: itemPhoto as? String, desc: itemDesc as? String, price: itemPrice as? String, quantity: "1")
                                self.itemList.append(item)
                            }
                            self.tots.append(self.itemList)
                            DispatchQueue.main.async {
                                self.itemTable.reloadData()
                            }
                        }
                        
                        
                    }
                }
                self.activityIndicator.stopAnimating()
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
    
    //MARK: - Side Menu Delegate
    func didSelectMenuItem(named: String) {
        
        switch named {
        case "Cart":
            sideMenu?.dismiss(animated: false, completion: nil)
            
            let cartController = self.storyboard?.instantiateViewController(identifier: Constants.Stroyboard.cartViewController) as! CartViewController
            navigationController?.pushViewController(cartController, animated: true)
            
            break
        case "Search":
            sideMenu?.dismiss(animated: false, completion: nil)
            
            let searchController = self.storyboard?.instantiateViewController(identifier: Constants.Stroyboard.searchViewController) as! SearchViewController
            navigationController?.pushViewController(searchController, animated: true)
            break
        case "Logout":
            loggedOut()
            break
        case "My Orders":
            sideMenu?.dismiss(animated: false, completion: nil)
            let orderController = self.storyboard?.instantiateViewController(identifier: Constants.Stroyboard.orderViewController) as! OrderViewController
            self.navigationController?.pushViewController(orderController, animated: true)
            break
        default:
            sideMenu?.dismiss(animated: true, completion: nil)
            
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Stroyboard.itemCell , for: indexPath) as! ItemTableViewCell
        let item: Model
        item = tots[indexPath.section][indexPath.row]
        cell.setCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var supp = String()
        for index in 0...section{
            supp = titleList[index]
        }
        return supp
    }
    
    
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
        itemTable.deselectRow(at: indexPath, animated: true)
        item = tots[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.Stroyboard.itemToDetailSegue, sender: item)
    }
    
    
    
}




