//
//  LoginViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/5/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {


    @IBOutlet weak var tfLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for res in result as! [NSManagedObject] {
                    if let username = res.value(forKey: "username") as? String {
                        tfUsername.text = username
                    }
                    
                    if let password = res.value(forKey: "password") as? String {
                        tfPassword.text = password
                    }
                }
            }
        }
        catch {
            print(error)
        }

    }

    @IBAction func btnLoginClick(_ sender: Any) {
        let username = tfUsername.text
        let password = tfPassword.text
        saveUserToCoreData(username: username!, password: password!)
        let scr = storyboard?.instantiateViewController(withIdentifier: "Slide") as! SlideViewController
        present(scr, animated: true, completion: nil)
    }
    @IBOutlet weak var btnRegisterClick: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveUserToCoreData(username: String, password: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        newUser.setValue(username, forKey: "username")
        newUser.setValue(password, forKey: "password")
        do {
            try context.save()
            print("SAVE")
        }
        catch {
            print(error)
        }
    }


}
