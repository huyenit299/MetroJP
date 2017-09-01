//
//  FavoriteController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/1/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mySegmentedControl = UISegmentedControl (items: ["One","Two","Three"])
        
        let xPostion:CGFloat = 10
        let yPostion:CGFloat = 150
        let elementWidth:CGFloat = 300
        let elementHeight:CGFloat = 30
        
        mySegmentedControl.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        
        // Make second segment selected
        mySegmentedControl.selectedSegmentIndex = 1
        
        //Change text color of UISegmentedControl
        mySegmentedControl.tintColor = UIColor.yellow
        
        //Change UISegmentedControl background colour
        mySegmentedControl.backgroundColor = UIColor.black
        
        // Add function to handle Value Changed events
        mySegmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        
        self.view.addSubview(mySegmentedControl)
    }
    
    func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
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
