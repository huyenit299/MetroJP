//
//  StationTableViewCell.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/28/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var selectStation: UISwitch!
    @IBOutlet weak var lbStation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
