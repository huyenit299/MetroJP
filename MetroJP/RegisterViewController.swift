//
//  RegisterViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/5/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var lbPassConfirm: UITextField!
    @IBOutlet weak var lbPass: UITextField!
    @IBOutlet weak var lbUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ユーザー登録"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnRegisterClick(_ sender: Any) {
        let username = lbUsername.text
        let pass = lbPass.text
        WebservicesHelper.addUser(username: username!, password: pass!)
    }
}
