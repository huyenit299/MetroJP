//
//  LeftController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class LeftController: UIViewController, UITextFieldDelegate {
    var exportViewController: UIViewController!
    @IBAction func btnLogoutClick(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnExportCSVClick(_ sender: Any) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let exportViewController = storyboard.instantiateViewController(withIdentifier: "ExportController") as! ExportController
        self.exportViewController = UINavigationController(rootViewController: exportViewController)
        self.slideMenuController()?.changeMainViewController(self.exportViewController, close: true)
    }
}
