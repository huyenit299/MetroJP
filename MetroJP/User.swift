//
//  User.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/15/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation

class UserModel {
    var id: Int = 0
    var username: String = ""
    var password: String = ""
    var token: String = ""
    init() {
    }
    
    init (id: Int, username: String, pass: String, token: String) {
        self.id = id
        self.username = username
        self.password = pass
        self.token = token
    }
}
