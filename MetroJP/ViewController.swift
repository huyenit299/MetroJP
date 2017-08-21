//
//  ViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func goToMainScreen(_ sender: AnyObject) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "Main") as! MainController
        present(scr, animated: true, completion: nil)
//        navigationController?.pushViewController(scr, animated: true)
    }
}

