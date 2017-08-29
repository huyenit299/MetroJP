//
//  TrafficItemView.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class TrafficItemView: UITableViewCell {

    @IBOutlet weak var selectStation: UISwitch!
    @IBOutlet weak var lbStation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        yourView.clipToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
