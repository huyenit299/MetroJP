//
//  Destination.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/5/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class Destination {
    var name: String = ""
    var type:Int = 1 //1: my list, 2: shared list
    var id: Int64 = -1
    init() {
    }
    
    init (id: Int64, name: String, type: Int) {
        self.name = name
        self.type = type
        self.id = id
    }
    
}
