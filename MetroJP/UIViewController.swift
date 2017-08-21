//
//  UIViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
    
        self.slideMenuController()?.removeLeftGestures()
    
        self.slideMenuController()?.addLeftGestures()
       
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil

        self.slideMenuController()?.removeLeftGestures()
        
    }
}
