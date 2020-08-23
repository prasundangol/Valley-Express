//
//  SearchTableViewCell.swift
//  SummerProject
//
//  Created by MacBook Air on 7/31/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemLabel: UILabel!
    
    var item: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(_ i:AnyObject){
        self.item = i
        
        //Ensure we have items in the database
        guard self.item != nil else{
            return
        }
        self.itemLabel.text = item?.string
        
        
    }
    
}
