//
//  Protocol.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/13/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

protocol DateSelectedProtocol {
    func getDateSelected (date: String, id: Int)//id of row
}

protocol SessionListDelegate {
    func getSessionList (listRecordTraffic: Array<RecordTrafficModel>)
}

protocol ChangeMonthDelegate {
    func changeMonth (month: String)
}

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
    func clickMore(section: Int)
    func clickAdd(section: Int, month: String)
}
