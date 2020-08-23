//
//  CartTableViewCell.swift
//  SummerProject
//
//  Created by MacBook Air on 8/3/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    var item: Model?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cartCell(_ i: Model){
        self.item = i
        
        
        itemLabel.text = item?.name
        
        quantityLabel.text = ("Quantity: ") + (item?.quantity)!
        
        priceLabel.text = ("Rs. ") + (item?.price)!
    }
    
    
}


