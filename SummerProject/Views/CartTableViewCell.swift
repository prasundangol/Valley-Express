//
//  CartTableViewCell.swift
//  SummerProject
//
//  Created by MacBook Air on 8/3/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
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
        
        titleLabel.text = item?.name
        descriptionLabel.text = item?.desc
        
        //Check whether there is a photo url or not
        guard self.item!.photo != "" else {
            return
        }
        
        //Check cache before downloading data
        if let cachedData = CacheManager.getImageCache(self.item!.photo!){
            //Set the thumbnail view
            self.itemImage.image = UIImage(data: cachedData)
            return
            
        }
        
        let url = URL(string: self.item!.photo!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil{
                //Save the data in the cache
                CacheManager.setImageCache(url!.absoluteString,data: data)
                
                //Check that the downloaded url matches the item image url that this cell is currently set to display
                if url?.absoluteString != self.item!.photo{
                    //Item cell has been recycled for another image and no longer matches the image that was downloaded
                    print("not mathced")
                    return
                }
                
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                self.itemImage.image = image
            }
            }
        }
        
        //Start the task
        dataTask.resume()
        
        
        
    }
    
    func removeData(){
        
        
    }

}
