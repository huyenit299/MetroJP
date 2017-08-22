//
//  Record.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//
import UIKit

class Record {
    var id: Int = 0
    var price: String = ""
    var date: String = ""
    var note: String = ""
    init() {
    }
    
    init (id: Int, price: String, date: String, note: String) {
        self.id = id
        self.price = price
        self.date = date
        self.note = note
    }
    public func setDate (date: String) {
        self.date = date
    }
    public func setPrice (price: String) {
        self.price = price
    }
    public func setNote (note: String) {
        self.note = note
    }
}
