//
//  BaseViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/12/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {
    let loading = ViewControllerUtils()
    let manager = NetworkReachabilityManager(host: "https://www.google.com.")

    override func viewWillAppear(_ animated: Bool) {
        manager?.listener = { status in
            
            print("Network Status Changed: \(status)")
            print("network reachable \(self.manager!.isReachable)")
            if (!(self.manager?.isReachable)!) {
                DispatchQueue.main.async {
                    print("Not reachable")
                    self.loading.showAlert(viewController: self)
                }
            }
        }
        manager?.startListening()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopListening()
    }
}
