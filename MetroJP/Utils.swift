//
//  Utils.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/1/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class Utils {
    public static func convertStringToDate (formatStyle: String, dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStyle
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+9") //Current time zone
        let date = dateFormatter.date(from: dateString) //according to date format your date string
        print(date ?? "") //Convert String to Date
        return date!
    }
    
    public static func convertDateToString (formatStyle: String, date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStyle
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+9") //Current time zone
        let dateString = dateFormatter.string(from: date) //pass Date here
        print(dateString) //New formatted Date string
        return dateString
    }
    
    public static func convertStringDateToStringDate (formatFromStyle: String, formatToStyle: String, dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatFromStyle
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+9") //Current time zone
        let date = dateFormatter.date(from: dateString) //according to date format your date string

        dateFormatter.dateFormat = formatToStyle
        let dateString = dateFormatter.string(from: date!) //pass Date here
        return dateString
    }
    
    public static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}
