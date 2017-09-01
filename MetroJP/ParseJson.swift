//
//  ParseJson.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/22/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class ParseJson {
    public func readJson() -> Array<DateSection>{
        var listRecord = Array<DateSection>()
        do {
            if let file = Bundle.main.url(forResource: "HardData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print("string-" + String(describing: object))
                    let items = object["data"] as! [AnyObject]
                    for item in items {
                        let dateSection = DateSection()
                        if let month = item["month"] as? String {
                                print(String(describing: month))
                            dateSection.month = month
                        }
                        if let total_price = item["total_price"] as? String {
                            print(String(describing: total_price))
                            dateSection.totalPrice = total_price
                        }
                        
                        let list_detail = item["data"] as! [AnyObject]
                        var listData = Array<RecordTrafficModel>()
                        for detail in list_detail {
                            let record = RecordTrafficModel()
                            if let date = detail["date"] as? String {
                                record.date = date
                            }
                            if let note = detail["note"] as? String {
                                record.note = note
                            }
                            if let price = detail["price"] as? String {
                                record.price = price
                            }
                            listData.append(record)
                        }
                        dateSection.list = listData
                        listRecord.append(dateSection)
                    }
                    
                } else if let object = json as? [Any] {
                    // json is an array
                    print("aray=" + String(describing: object))
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return listRecord
    }
}
