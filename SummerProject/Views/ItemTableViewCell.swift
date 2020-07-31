//
//  ItemTableViewCell.swift
//  SummerProject
//
//  Created by MacBook Air on 7/20/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
   
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: Model?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ i: Model){
        self.item = i
        
        //Ensure we have items in the database
        guard self.item != nil else{
            return
        }
        
        //Set the title
        self.titleLabel.text = item?.name
        
        //Set the description
        self.descriptionLabel.text = item?.desc
        
        //Check where there is a photo url or not
        guard self.item!.photo != "" else {
            return
        }
        
        let url = URL(string: self.item!.photo!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                self.photoView.image = image
            }
            
        }
        
        //Start the task
        dataTask.resume()
        
        
    }
    


}
