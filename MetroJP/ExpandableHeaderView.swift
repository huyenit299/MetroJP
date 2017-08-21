//
//  ExpandableHeaderView.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/18/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}
class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    @IBOutlet weak var lbName: UILabel!

    @IBOutlet weak var lbPrice: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    func selectHeaderView(gesture: UITapGestureRecognizer) {
        let cell = gesture.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(date: String, price_right: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.lbName.text = date
        self.lbPrice.text = price_right
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
