//
//  RecordStation.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/30/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class RecordStation {
    var id: Int!
    var date: String!
    var listTraffic: Array<Station> = []
    var from: String!
    var to: String!
    var amount: Int!
    var note: String!
    init() {
    }

    init (id: Int, date: String, listTraffic: Array<Station>, from: String, to: String, amount: Int, note: String) {
        self.id = id
        self.date = date
        self.listTraffic = listTraffic
        self.from = from
        self.to = to
        self.amount = amount
        self.note = note
    }
}
