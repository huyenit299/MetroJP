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
    var list = Array<RecordTrafficModel?>()
    var expand: Bool = false
    var active: Bool = false
    init() {
    }
    
    init (month: String, totalPrice: String, list: Array<RecordTrafficModel>) {
        self.month = month
        self.totalPrice = totalPrice
        self.list = list
    }
  
}

