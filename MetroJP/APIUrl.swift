//
//  APIUrl.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/8/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation


//let SERVER_URL = "http://192.168.1.218:8018"
let SERVER_URL = "http://192.168.1.126:8018"
let LOGIN = SERVER_URL + "/user/login"
let LOGOUT = SERVER_URL + "/user/logout"
let REGISTER = SERVER_URL + "/user/add"
let EDIT_USER = SERVER_URL + "/user/update"
let LIST_SESSION = SERVER_URL + "/session/list"
let LIST_MONTH = SERVER_URL + "/session/month"
let ADD_SESSION = SERVER_URL + "/session/add"
let UPDATE_SESSION = SERVER_URL + "/session/update"
let DELETE_SESSION = SERVER_URL + "/session/delete"
let LIST_FAVORITE = SERVER_URL + "/favorite/list"
let ADD_FAVORITE = SERVER_URL + "/favorite/add"
let UPDATE_FAVORITE = SERVER_URL + "/favorite/update"
let DELETE_FAVORITE = SERVER_URL + "/favorite/delete"
let SEARCH = SERVER_URL + "/search"
let FARE = SERVER_URL + "/fare"
