//
//  TrafficItemView.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit


protocol SelectSwitchDelegate {
    func clickSwitch(row: Int)
}

class TrafficItemView: UITableViewCell {
    var delegate: SelectSwitchDelegate?
    @IBAction func switchSelect(_ sender: Any) {
        delegate?.clickSwitch(row: row)
    }
    @IBOutlet weak var selectStation: UISwitch!
    @IBOutlet weak var lbStation: UILabel!
    var row: Int!

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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSwitchView)))
    }
    
    func selectSwitchView(gesture: UITapGestureRecognizer) {
        let cell = gesture.view as! TrafficItemView
        delegate?.clickSwitch(row: cell.row)
    }

}
