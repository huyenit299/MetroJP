//
//  LeftPaddedTextField.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/31/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
         return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}
