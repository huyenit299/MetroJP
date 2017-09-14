//
//  ExpandableHeaderView.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/18/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit


class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!

    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lbName: UILabel!

    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var lbPrice: UILabel!

    @IBAction func addNewRecord(_ sender: Any) {
        delegate?.clickAdd(section: section, month: lbName.text!)
    }

    @IBAction func btnMore(_ sender: Any) {
        delegate?.clickMore(section: section)
    }
    
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
