//
//  Section.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/18/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

struct Section {
    var date: String = ""
    var price_right: String = ""
    var price: [String]!
    var expand: Bool!
    
    init (date: String, price_right: String, price: [String], expand: Bool) {
        self.date = date
        self.price_right = price_right
        self.price = price
        self.expand = expand
    }
}


