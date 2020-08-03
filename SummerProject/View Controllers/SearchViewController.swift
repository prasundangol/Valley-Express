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
    
    var tots = [SearchModel]()
    var keys = String()
    var titleList = [String]()
    var itemList = [SearchModel]()
    var ref = Database.database().reference().child("items")
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    var searching  = false
    var searched = [AnyObject]()
    

    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        getItems()
        setupSearchBar()
        

    }
    

    //Seting up navigation bar
    private func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 218/255, green: 56/255, blue: 50/255, alpha: 1)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide" , size: 19)]
        navigationController?.navigationBar.titleTextAttributes = attribute as [NSAttributedString.Key : Any]
        
    }
    
    private func setupSearchBar(){
        searchBar.placeholder = "Search"
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        textFieldInsideSearchBar?.textColor = .white

        
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
                                let item = SearchModel(name: itemName as? String)
                                self.itemList.append(item)
                             }
                            self.tots.append(contentsOf: self.itemList)
                            print(self.tots)
                            DispatchQueue.main.async {
                                self.searchTableView.reloadData()
    }
                         }
                         
                         
                     }
                }
            }
            
        }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searched.count
        }
        else{
            return tots.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        let item: SearchModel
        item = tots[indexPath.row]
        if searching{
            cell.itemLabel.text = searched[indexPath.row] as? String
        }
        else{
            cell.setCell(item)

        }

        return cell
    }
    
    
    
    
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searched = tots as [AnyObject]
        if searchText.isEmpty == false {
            searched = tots.filter({return $0.name == searchText}) as [AnyObject]
            searching = true
        }
        DispatchQueue.main.async {
            self.searchTableView.reloadData()

        }
        
    }

}
