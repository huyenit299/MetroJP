//
//  DatabaseManager.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/30/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//
import SQLite

class DatabaseManagement {
    static var shared = DatabaseManagement()
    private let db: Connection?
    let tblTraffic = Table("RecordTraffic")
    let id = Expression<Int64>("id")
    let date = Expression<String>("date")
    let target = Expression<String>("target")
    let from = Expression<String>("from")
    let to = Expression<String>("to")
    let traffics = Expression<String>("traffic")
    let price = Expression<String>("price")
    let note = Expression<String>("note")
    
    private init() {
        do {
            db = try Connection("/Users/huyennguyen/Documents/ios/MetroJP/MetroJPDB.sqlite")
            print ("open database")
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func addTraffic(_date: String, _target: String, _from: String, _to: String, _traffics: String, _price: String, _note: String) -> Int64? {
        do {
            let insert = tblTraffic.insert(date <- _date, target <- _target, from <- _from, to <- _to, traffics <- _traffics, price <- _price, note <- _note)
            let id = try db!.run(insert)
            print("Insert to tblTraffic successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllTraffic() -> [RecordTrafficModel] {
        var listTraffic: Array<RecordTrafficModel> = []
        if (db != nil) {
            do {
                let list = try self.db!.prepare(self.tblTraffic)
                 for t in list {
                    print("id: \(t[id]) ; target = \(String(describing: t[price]))")
                    listTraffic.append(RecordTrafficModel(id: Int((t[id])), date: (t[date]), target: (t[target]), from: (t[from]), to: (t[to]), traffic: (t[traffics]), price: (t[price]), note: (t[note])))
                }
            } catch {
                print(error)
            }
        }
//        for traffic in listTraffic {
//            print("each traffic = \(traffic)")
//        }
        return listTraffic
    }
    
    func updateTraffic(trafficId:Int64, newTraffic: RecordTrafficModel) -> Bool {
        let tbTrafficFilter = tblTraffic.filter(id == trafficId)
        do {
            let update = tbTrafficFilter.update([
                    date <- newTraffic.date, target <- newTraffic.target, from <- newTraffic.from, to <- newTraffic.to, traffics <- newTraffic.traffic, price <- newTraffic.price, note <- newTraffic.note
                ])
            if try db!.run(update) > 0 {
                print("Update traffic successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteTraffic(trafficId: Int64) -> Bool {
        do {
            let tblFilterTraffic = tblTraffic.filter(id == trafficId)
            try db!.run(tblFilterTraffic.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
}
