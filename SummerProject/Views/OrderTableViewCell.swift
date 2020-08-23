//
//  OrderTableViewCell.swift
//  SummerProject
//
//  Created by MacBook Air on 8/22/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var orderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCell(item: String){
        orderDate.text = item
        
    }
    
}
