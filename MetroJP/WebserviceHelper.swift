//
//  WebserviceHelper.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/8/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import UIKit

class WebservicesHelper {
    static let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    static func getToken() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for res in result as! [NSManagedObject] {
                    if let token = res.value(forKey: "token") as? String {
                        print("return token-ws=" + token)
                        return token
                    }
                }
            }
        }
        catch {
            print(error)
        }
        return ""
    }
    
    public static func login (username: String, password: String, loginDelegate: LoginDelegate) {
        let parameters: Parameters = ["username": username, "password": password]
        
        Alamofire.request(LOGIN, method: .post,parameters: parameters, headers: headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            let token = ParseJson.loginParser(jsonData: response.data!)
            loginDelegate.loginComplete(tokenRes: token)
        }

    }
    
    public static func logout () {
        //get token
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token ]
            Alamofire.request(LOGOUT, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
    
    public static func addUser(username: String, password: String) {
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request(REGISTER, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                            print("Request: \(String(describing: response.request))")   // original url request
                            print("Response: \(String(describing: response.response))") // http url response
                            print("Result: \(response.result)")                         // response serialization result
                
                            if let json = response.result.value {
                                print("JSON: \(json)") // serialized json response
                            }
                
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }

            }
    }
    
    public static func updateUser(username: String, password: String) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "username": username, "password": password]
            Alamofire.request(UPDATE_SESSION, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print(response)
            }
        }
    }

    public static func getListMonth(delegate: ListMonthDelegate) {
        //        let token = getToken()
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token]
            Alamofire.request(LIST_MONTH, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ParseJson.listMonthParser(jsonData: data, delegate: delegate)
                }
            }
        }
    }
    
    public static func getListSession(sessionDelegate: SessionListDelegate, month: String) {
//        let token = getToken()
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "month": month ?? ""]
            Alamofire.request(LIST_SESSION, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                if (response.response == nil ) {
                    sessionDelegate.getSessionList(listRecordTraffic: Array<RecordTrafficModel>())
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ParseJson.listSessionParser(jsonData: data, delegate: sessionDelegate)
                }
            }
        }
    }
    
    public static func getListSession(sessionDelegate: SessionListDelegate) {
        //        let token = getToken()
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token ]
            Alamofire.request(LIST_SESSION, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ParseJson.listSessionParser(jsonData: data, delegate: sessionDelegate)
                }
            }
        }
    }

    public static func getListSessionByDate(sessionDelegate: SessionListDelegate, start: String, end: String) {
        //        let token = getToken()
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "start": start, "end": end ]
            Alamofire.request(LIST_SESSION_DATE, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ParseJson.listSessionParser(jsonData: data, delegate: sessionDelegate)
                }
            }
        }
    }
    
    public static func addSession(date: String, target:String, traffic: String, from: String, to: String, fare: String, remarks: String) {
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "date": date, "target": target, "traffic": traffic, "from": String(), "to": to, "fare": fare, "remarks": remarks ]
            Alamofire.request(ADD_SESSION, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
    
    public static func updateSession(sessionId: Int, date: String, target:String, traffic: String, from: String, to: String, fare: String, remarks: String) {
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "id": sessionId, "date": date, "target": target, "traffic": traffic, "from": from, "to": to, "fare": fare, "remarks": remarks  ]
            Alamofire.request(UPDATE_SESSION, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }            }
        }
    }
    
    public static func deleteSession(sessionId: Int) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "id": sessionId]
            Alamofire.request(DELETE_SESSION, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
    
    public static func getListFavorite(delegate: FavoriteDelegate, type: Int) {
        let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "type": type ]
            Alamofire.request(LIST_FAVORITE, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ParseJson.listFavoriteParser(jsonData: data, delegate: delegate)
                }
            }
        }
    }
    
    public static func addFavorite(sessionId: Int, common: Bool) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "session_id": sessionId, "common": common]
            Alamofire.request(ADD_FAVORITE, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
    
    public static func updateFavorite(favoriteId: Int, sessionId: Int, common: Int) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "id": favoriteId, "session_id": sessionId, "common": common]
            Alamofire.request(UPDATE_FAVORITE, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
    
    public static func deleteFavorite(favoriteId: Int) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "id": favoriteId]
            Alamofire.request(DELETE_FAVORITE, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }

    public static func search(keyword: String) {
 let token = Constant.token
        if (!(token.isEmpty)) {
            let parameters: Parameters = ["token": token, "keyword": keyword]
            Alamofire.request(SEARCH, method: .get,parameters: parameters, headers: headers).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
}
