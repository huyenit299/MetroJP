//
//  RegisterViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/5/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, RegisterUserDelegate {

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
        let passConfirm = lbPassConfirm.text
        if (username?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError.EMAIL, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (Utils.isValidEmailAddress(emailAddressString: username!)) {
            let alert = UIAlertController(title: "", message: RecordError.EMAIL_VALIDATE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (pass?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError.PASS, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (pass != passConfirm) {
            let alert = UIAlertController(title: "", message: RecordError.PASS_MATCH, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        loading.showActivityIndicator(uiView: self.view)
        WebservicesHelper.addUser(username: username!, password: pass!)
    }
    
    func addUser (user: UserModel) {
        loading.hideActivityIndicator(uiView: self.view)
        if (!user.username.isEmpty) {
            let alert = UIAlertController(title: "", message: RecordError.REGISTER_SUCCESS, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: RecordError.REGISTER_FAILURE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
