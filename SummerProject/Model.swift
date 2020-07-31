//
//  Model.swift
//  SummerProject
//
//  Created by MacBook Air on 7/23/20.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import Foundation

class Model{
    var name: String?
    var photo: String?
    var desc: String?
    
    init(name: String, photo: String, desc: String){
        self.name = name
        self.photo = photo
        self.desc = desc
        
    }
    
}

struct SearchModel{
    var name: String?
    
}
