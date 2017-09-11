//
//  FavoriteModel.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/11/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class FavoriteModel {
    var id: Int!
    var date: String = ""
    var target: String = ""
    var from: String = ""
    var to: String = ""
    var price: String = ""
    var traffic: String = ""
    var note: String = ""
    var session_id: Int!
    var common: Int = 0
    init() {
    }
    init(id: Int, date: String, target: String, from: String, to: String, traffic: String, price: String, note: String, session_id: Int, common: Int) {
        self.id = id
        self.date = date
        self.target = target
        self.from = from
        self.to = to
        self.traffic = traffic
        self.price = price
        self.note = note
        self.session_id = session_id
        self.common = common
    }
}
