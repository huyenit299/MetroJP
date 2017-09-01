//
//  RecordTraffic.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/30/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class RecordTrafficModel {
    var id: Int!
    var date: String = ""
    var target: String = ""
    var from: String = ""
    var to: String = ""
    var price: String = ""
    var traffic: String = ""
    var note: String = ""
    init() {
    }
    init(id: Int, date: String, target: String, from: String, to: String, traffic: String, price: String, note: String) {
        self.id = id
        self.date = date
        self.target = target
        self.from = from
        self.to = to
        self.traffic = traffic
        self.price = price
        self.note = note
    }
}
