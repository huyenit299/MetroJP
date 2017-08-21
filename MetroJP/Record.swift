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
    var name: String = ""
    var price: Int = 0
    init (id: Int, name: String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
}
