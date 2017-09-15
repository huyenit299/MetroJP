//
//  RegisterViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/5/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: BaseViewController, RegisterUserDelegate {

    @IBOutlet weak var lbPassConfirm: UITextField!
    @IBOutlet weak var lbPass: UITextField!
    @IBOutlet weak var lbUsername: UITextField!
    var isEdit: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ユーザー登録"
        if (isEdit) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            //        request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                if result.count > 0 {
                    for res in result as! [NSManagedObject] {
                        if let username = res.value(forKey: "username") as? String {
                            lbUsername.text = username
                        }
                        
                        if let password = res.value(forKey: "password") as? String {
                            lbPass.text = password
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }
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
        if (isEdit) {
            WebservicesHelper.updateUser(username: username!, password: pass!, delegate: self)
        } else {
            WebservicesHelper.addUser(username: username!, password: pass!, delegate: self)
        }
    }
    
    func addUser (user: UserModel) {
        loading.hideActivityIndicator(uiView: self.view)
        if (!user.username.isEmpty) {
            if (isEdit) {
                let alert = UIAlertController(title: "", message: RecordError.UPDATE_USER_SUCCESS, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "", message: RecordError.REGISTER_SUCCESS, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if (isEdit) {
                let alert = UIAlertController(title: "", message: RecordError.UPDATE_USER_FAILURE, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "", message: RecordError.REGISTER_FAILURE, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
