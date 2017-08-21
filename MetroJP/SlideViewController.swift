//
//  SlideViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/21/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class SlideViewController: SlideMenuController {

    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftMenu")
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = navigationController
        leftViewController = leftVC
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
