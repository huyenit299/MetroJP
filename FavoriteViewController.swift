//
//  FavoriteViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/22/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class FavoriteViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.tabBar.frame = CGRect(origin: CGPoint(x: 0,y :64), size: CGSize(width: screenWidth, height: 60))
//        let newTabbar = UITabBarItem(title: "3", image: nil, tag: 0)
//        self.tabBar.items?.append(newTabbar)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
