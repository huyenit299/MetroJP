//
//  LeftController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

class LeftController: UIViewController, UITextFieldDelegate {
    var exportViewController: UIViewController!
    
    @IBOutlet weak var btnName: UIButton!
    @IBAction func btnLogoutClick(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showUserInfo()
    }

    @IBAction func btnNameClick(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        scr.isEdit = true
        self.slideMenuController()?.changeMainViewController(scr, close: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnExportCSVClick(_ sender: Any) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scr = storyboard.instantiateViewController(withIdentifier: "ExportController") as! ExportController
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    func showUserInfo() {
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
                        btnName.setTitle(username, for: .normal)
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
}
