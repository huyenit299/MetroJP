//
//  ViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var lbUsername: UITextField!
    @IBOutlet weak var lbPassword: UITextField!
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
                        lbUsername.text = username
                    }
                    
                    if let password = res.value(forKey: "password") as? String {
                        lbPassword.text = password
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
        }
    }

    @IBAction func btnRegisterClick(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(scr, animated: true)
        
    }
    @IBAction func goToMainScreen(_ sender: AnyObject) {
        let username = lbUsername.text
        let password = lbPassword.text
        saveUserToCoreData(username: username!, password: password!)

        let scr = storyboard?.instantiateViewController(withIdentifier: "Slide") as! SlideViewController
//        let scr = storyboard?.instantiateViewController(withIdentifier: "FoldingCellTable") as! FoldingCellTableController
        present(scr, animated: true, completion: nil)
//        navigationController?.pushViewController(scr, animated: true)
    }
}

