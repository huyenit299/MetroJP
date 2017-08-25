//
//  Station.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/25/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class Station {
    var id: Int = 0
    var name: String = ""
    var select: Bool = false
    
    init() {
    }
    
    init (id: Int, name: String, select: Bool) {
        self.id = id
        self.name = name
        self.select = select
    }

}
