//
//  SectionTableCell.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/21/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class SectionTableCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
