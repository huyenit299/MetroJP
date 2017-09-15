//
//  ParseJson.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/22/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class ParseJson {
    public static func loginParser(jsonData: Data)->String{
        do{
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        if let object = json as? [String: Any] {
            // json is a dictionary
            print("string-" + String(describing: object))
            let items = object["data"] as! [String:Any]
           
                if let token = items["token"] as? String {
                    print(String(describing: token))
                    return token
                }
            }
        }catch{
            print(error)
        }
        return ""
    }
    
    public static func addUserParser (jsonData: Data) -> UserModel {
        var user = UserModel()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                print("string-" + String(describing: object))
                let item = object["data"] as! NSDictionary
                if let userObj = item["data"] as? [AnyObject] {
                    if let username = userObj["username"] as? String {
                        print(username)
                        user.username = username
                    }
                    if let password = userObj["password"] as? String {
                        print(password)
                        user.password = password
                    }
                    if let token = userObj["token"] as? String {
                        print(token)
                        user.token = token
                    }
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return user
    }
    
    public static func listSessionParser(jsonData: Data, delegate: SessionListDelegate)->Array<RecordTrafficModel>{
        var listRecordTraffic: Array<RecordTrafficModel> = []
        do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print("string-" + String(describing: object))
                    let item = object["data"] as! NSDictionary
                    if let sessions = item["listSession"] as? NSDictionary {

                        let i = sessions as NSDictionary
                        let enumerator = i.keyEnumerator()
                        while let key = enumerator.nextObject() {
                            let record = RecordTrafficModel()
                            let session = i[key] as! NSDictionary
                            if let date = session["date"] as? String {
                                print(date)
                                record.date = date
                            }
                            if let fare = session["fare"] as? String {
                                print(fare)
                                record.price = fare
                            }
                            if let from = session["from"] as? String {
                                print(from)
                                record.from = from
                            }
                            if let id = session["id"] as? Int {
                                record.id = id
                            }
                            if let remarks = session["remarks"] as? String {
                                print(remarks)
                                record.note = remarks
                            }
                            if let target = session["target"] as? String {
                                print(target)
                                record.target = target
                            }
                            if let to = session["to"] as? String {
                                print(to)
                                record.to = to
                            }
                            if let traffic = session["traffic"] as? String {
                                print(traffic)
                                record.traffic = traffic
                            }
                            listRecordTraffic.append(record)
                        }
                    }
                } else if let object = json as? [Any] {
                    // json is an array
                    print("aray=" + String(describing: object))
                } else {
                    print("JSON is invalid")
                }
            delegate.getSessionList(listRecordTraffic: listRecordTraffic)
            
            DatabaseManagement.shared.deleteAllRecordTraffic()
            if (listRecordTraffic.count > 0) {
                DatabaseManagement.shared.bulkInsertRecordTraffic(list: listRecordTraffic)
            }
        } catch {
            print(error.localizedDescription)
        }
        return listRecordTraffic
    }
    
    public static func listFavoriteParser(jsonData: Data, delegate: FavoriteDelegate){
        var listFavorite: Array<FavoriteModel> = []
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                print("string-" + String(describing: object))
                let item = object["data"] as! NSDictionary
                if let sessions = item["listFavorite"] as? [AnyObject] {
                    
                    for session in sessions {
                        let record = FavoriteModel()
                        if let date = session["date"] as? String {
                            print(date)
                            record.date = date
                        }
                        if let fare = session["fare"] as? String {
                            print(fare)
                            record.price = fare
                        }
                        if let from = session["from"] as? String {
                            print(from)
                            record.from = from
                        }
                        if let id = session["id"] as? String {
                            print("id=" + id)
                            record.id = Int(id)
                        }
                        if let remarks = session["remarks"] as? String {
                            print(remarks)
                            record.note = remarks
                        }
                        if let target = session["target"] as? String {
                            print(target)
                            record.target = target
                        }
                        if let to = session["to"] as? String {
                            print(to)
                            record.to = to
                        }
                        if let traffic = session["traffic"] as? String {
                            print(traffic)
                            record.traffic = traffic
                        }
                        if let session_id = session["session_id"] as? String {
                            print(session_id)
                            record.session_id = Int(session_id)
                        }
                        if let common = session["common"] as? String {
                            print(common)
                            record.common = Int(common)!
                        }
                        listFavorite.append(record)
                    }
                }
            } else if let object = json as? [Any] {
                // json is an array
                print("aray=" + String(describing: object))
            } else {
                print("JSON is invalid")
            }
            
            delegate.getListFavorite(listFavorite: listFavorite)
            
            DatabaseManagement.shared.deleteAllFavorite()
            if (listFavorite.count > 0) {
                DatabaseManagement.shared.bulkInsertFavorite(list: listFavorite)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public static func listMonthParser(jsonData: Data, delegate: ListMonthDelegate)->Array<String>{
        var listMonths: Array<String> = []
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                print("string-" + String(describing: object))
                let item = object["data"] as! NSDictionary
                if let sessions = item["listMonth"] as? [AnyObject] {
                    for session in sessions {
                        if let date = session["date"] as? String {
                            listMonths.append(Utils.convertStringDateToStringDate(formatFromStyle: Constant.DATE_STANDARD, formatToStyle: Constant.MONTH_YEAR_STANDARD, dateString: date))
                        }
                    }
                }
            } else if let object = json as? [Any] {
                // json is an array
                print("aray=" + String(describing: object))
            } else {
                print("JSON is invalid")
            }
            delegate.getListMonth(months: listMonths)
        } catch {
            print(error.localizedDescription)
            delegate.getListMonth(months: listMonths)
        }
        return listMonths
    }

    
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
