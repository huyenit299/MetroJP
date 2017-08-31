//
//  Traffic.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/31/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class TrafficModel {
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
