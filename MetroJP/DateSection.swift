//
//  DateSection.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/17/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class DateSection {
    var month: String = ""
    var totalPrice: String = ""
    var list = Array<Record?>()
    var expand: Bool = false
    init() {
    }
    
    init (month: String, totalPrice: String, list: Array<Record>) {
        self.month = month
        self.totalPrice = totalPrice
        self.list = list
    }
  
}

