//
//  ViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData
import Foundation


protocol LoginDelegate {
    func loginComplete(tokenRes: String)
}

class ViewController: BaseViewController, LoginDelegate {
    @IBOutlet weak var lbUsername: UITextField!
    @IBOutlet weak var lbPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //storing core data
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
                        lbPassword.text = password
                    }
                    if let token = res.value(forKey: "token") as? String {
                        print("return token-" + token)
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveUserToCoreData(username: String, password: String, token: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        newUser.setValue(username, forKey: "username")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(token, forKey: "token")
        do {
            try context.save()
            print("SAVE")
        }
        catch {
        }
    }

    @IBAction func btnRegisterClick(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(scr, animated: true)
        
    }
    @IBAction func goToMainScreen(_ sender: AnyObject) {
        let username = lbUsername.text
        let password = lbPassword.text
        loading.showActivityIndicator(uiView: self.view)
        WebservicesHelper.login(username: username!, password: password!,loginDelegate: self)
     
    }
    
    func loginComplete(tokenRes: String) {
        Constant.token = tokenRes
        print("token-" + Constant.token)
        let username = lbUsername.text
        let password = lbPassword.text
        saveUserToCoreData(username: username!, password: password!, token: Constant.token)
        
        loading.hideActivityIndicator(uiView: self.view)
        
        let scr = storyboard?.instantiateViewController(withIdentifier: "Slide") as! SlideViewController
        present(scr, animated: true, completion: nil)
    }
}

