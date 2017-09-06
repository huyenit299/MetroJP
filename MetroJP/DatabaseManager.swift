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
    
    //table recordTraffic
    let tblRecordTraffic = Table("RecordTraffic")
    let id = Expression<Int64>("id")
    let date = Expression<String>("date")
    let target = Expression<String>("target")
    let from = Expression<String>("from")
    let to = Expression<String>("to")
    let traffics = Expression<String>("traffic")
    let price = Expression<String>("price")
    let note = Expression<String>("note")
    
    //table traffic
    let tblTraffic = Table("Traffic")
    let name = Expression<String>("name")
    
    //table destination
    let tblDestination = Table("Destination")
    let type = Expression<Int>("type")

    
    private init() {
        do {
            db = try Connection("/Users/huyennguyen/Documents/ios/MetroJP/MetroJPDB.sqlite")
            print ("open database")
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func addRecordTraffic(_date: String, _target: String, _from: String, _to: String, _traffics: String, _price: String, _note: String) -> Int64? {
        do {
            let insert = tblRecordTraffic.insert(date <- _date, target <- _target, from <- _from, to <- _to, traffics <- _traffics, price <- _price, note <- _note)
            let id = try db!.run(insert)
            print("Insert to tblTraffic successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllRecordTraffic() -> [RecordTrafficModel] {
        var listRecordTraffic: Array<RecordTrafficModel> = []
        if (db != nil) {
            do {
                let list = try self.db!.prepare(self.tblRecordTraffic)
                 for t in list {
                    print("id: \(t[id]) ; target = \(String(describing: t[price]))")
                    listRecordTraffic.append(RecordTrafficModel(id: Int(t[id]), date: (t[date]), target: (t[target]), from: (t[from]), to: (t[to]), traffic: (t[traffics]), price: (t[price]), note: (t[note])))
                }
            } catch {
                print(error)
            }
        }
        return listRecordTraffic
    }
    
    
    func queryAllRecordTraffic(fromDate: String, toDate: String) -> [RecordTrafficModel] {
        var listRecordTraffic: Array<RecordTrafficModel> = []
        if (db != nil) {
            do {
                let list = try self.db!.prepare("SELECT * FROM RecordTraffic WHERE date >= '" + fromDate + "' AND date <= '" + toDate+"'")
                for t in list {
                    listRecordTraffic.append(RecordTrafficModel(id: Int(t[0] as! Int64), date: t[1] as! String, target: t[2] as! String, from: t[4] as! String, to: t[5] as! String, traffic: t[3] as! String, price: t[6] as! String, note: t[7] as! String))
                }
            } catch {
                print(error)
            }
        }
        return listRecordTraffic
    }
    
    func queryRecordTraffic(trafficId: Int64) -> RecordTrafficModel {
        var record = RecordTrafficModel()
        if (db != nil) {
            do {
                 let tbTrafficFilter = tblRecordTraffic.filter(id == trafficId)
                 let list = try self.db!.prepare(tbTrafficFilter)
                 for t in list {
                    print("id: \(t[id]) ; target = \(String(describing: t[price]))")
                    record = RecordTrafficModel(id: Int(t[id]), date: t[date], target: t[target], from: t[from], to: t[to], traffic: t[traffics], price: t[price], note: t[note])
                }
            } catch {
                print(error)
            }
        }
        return record
    }

    
    func updateRecordTraffic(trafficId:Int64, newTraffic: RecordTrafficModel) -> Bool {
        let tbTrafficFilter = tblRecordTraffic.filter(id == trafficId)
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
    
    func deleteRecordTraffic(trafficId: Int) -> Bool {
        do {
            let tblFilterTraffic = tblRecordTraffic.filter(id == Int64(trafficId))
            try db!.run(tblFilterTraffic.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    func queryAllTraffic() -> [TrafficModel] {
        var listTraffic: Array<TrafficModel> = []
        if (db != nil) {
            do {
                let list = try self.db!.prepare(self.tblTraffic)
                for t in list {
                    listTraffic.append(TrafficModel(id: Int((t[id])), name: (t[name]), select: false))
                }
            } catch {
                print(error)
            }
        }
        return listTraffic
    }
    
    func queryMapTraffic() -> [String: String] {
        var listTraffic: [String: String] = [:]
        if (db != nil) {
            do {
                let list = try self.db!.prepare(self.tblTraffic)
                for t in list {
                    listTraffic[String(t[id])] = t[name]
                }
            } catch {
                print(error)
            }
        }
        return listTraffic
    }
    
    /*
     *Destination
     */
    func addDestination(_name: String, _type: Int) -> Int64? {
        do {
            let insert = tblDestination.insert(name <- _name, type <- _type)
            let id = try db!.run(insert)
            print("addDestination successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllDestination(_type: Int) -> [Destination] {
        var listDestination: Array<Destination> = []
        if (db != nil) {
            do {
                let tbDestinationFilter = tblDestination.filter(type == _type)
                let list = try self.db!.prepare(tbDestinationFilter)
                for t in list {
                    listDestination.append(Destination(id: (t[id]), name: (t[name]), type: (t[type])))
                }
            } catch {
                print(error)
            }
        }
        return listDestination
    }
    
    func queryDestination(destinationId: Int64) -> Destination {
        var destination = Destination()
        if (db != nil) {
            do {
                let tbDestinationFilter = tblDestination.filter(id == destinationId)
                let list = try self.db!.prepare(tbDestinationFilter)
                for t in list {
                    destination = Destination(id: t[id], name: t[name], type: t[type])
                }
            } catch {
                print(error)
            }
        }
        return destination
    }
    
    
    func updateDestination(destinationId: Int64, newDestination: Destination) -> Bool {
        let tbDestinationFilter = tblDestination.filter(id == destinationId)
        do {
            let update = tbDestinationFilter.update([
                name <- newDestination.name, type <- newDestination.type])
            if try db!.run(update) > 0 {
                print("updateDestination successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteDestination(destinationId: Int64) -> Bool {
        do {
            let tbDestinationFilter = tblDestination.filter(id == destinationId)
            try db!.run(tbDestinationFilter.delete())
            print("deleteDestination sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    /*
     *End Destination
     */
}


