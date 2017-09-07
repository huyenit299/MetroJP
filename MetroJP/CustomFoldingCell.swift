//
//  CustomFoldingCell.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/22/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class CustomFoldingCell: FoldingCell {

    @IBOutlet weak var lbClose: UILabel!
    @IBOutlet weak var lbOpen: UILabel!
    var number: Int = 0 {
        didSet {
            lbClose.text = String(number)
            lbOpen.text = String(number)
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    

}
