//
//  SearchViewController.swift
//  SummerProject
//
//  Created by MacBook Air on 7/31/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    var keys = String()
    var titleList = [String]()
    var itemList = [Model]()
    var ref = Database.database().reference().child("items")
    let searchController = UISearchController(searchResultsController: nil)
    var itemsArray = [NSDictionary]()
    var filteredItems = [NSDictionary]()
    
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchTableView.tableHeaderView = searchController.searchBar
        searchTableView.delegate = self
        searchTableView.dataSource = self
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
        ref.observe(.value) { (snap) in
            for child in snap.children{
                let data = child as! DataSnapshot
                self.keys = data.key
                self.titleList.append(self.keys)
                self.ref.child(self.keys).queryOrdered(byChild: "item").observe(.childAdded , with: { (snapshot) in
                    self.itemsArray.append(snapshot.value as! NSDictionary)
                    
                    self.searchTableView.insertRows(at: [IndexPath(row: self.itemsArray.count-1, section: 0)], with: .automatic)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            self.activityIndicator.stopAnimating()
            
        }
        
    }
    //Moving data to view at detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Stroyboard.searchToDetailSegue{
            let destVC = segue.destination as! DetailViewController
            destVC.item = sender as? Model
            
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredItems.count
            
        }
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        let item: NSDictionary?
        let test: Model?
        if searchController.isActive && searchController.searchBar.text != ""{
            //itemList.removeAll()
            item = filteredItems[indexPath.row]
            test = Model(name: item!["item"] as? String, photo: item!["photo"] as? String, desc: item!["desc"] as? String, price: item!["price"] as? String, quantity: "1")
        }
        else{
            item = self.itemsArray[indexPath.row]
            test = Model(name: item!["item"] as? String, photo: item!["photo"] as? String, desc: item!["desc"] as? String, price: item!["price"] as? String, quantity: "1")
        }
        cell.itemLabel.text = item?["item"] as? String
        
        itemList.append(test!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Model
        searchTableView.deselectRow(at: indexPath, animated: true)
        item = itemList[indexPath.row]
        performSegue(withIdentifier: Constants.Stroyboard.searchToDetailSegue, sender: item)
    }
    
    
    
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filteredContent(searchText: String){
        self.filteredItems = self.itemsArray.filter{item in
            let itemName = item["item"] as? String
            return((itemName?.lowercased().contains(searchText.lowercased())))!
            
        }
        searchTableView.reloadData()
        itemList.removeAll()
        
    }
    
    
}
