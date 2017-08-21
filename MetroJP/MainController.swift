//
//  MainController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import Alamofire
import JTAppleCalendar

class MainController: SlideMenuController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    @IBOutlet weak var mainTable: UITableView!
    var data = [Record]();
    
    var sections = [
        Section(date: "🦁 Animation",
                price_right: "Lion King",
                price: ["The Lion King", "The Incredibles"],
                expand: false),
        Section(date: "💥 Superhero",
                price_right: "Lion King",
                price: ["Guardians of the Galaxy"],
                expand: false),
        Section(date: "👻 Horror",
                price_right: "Lion King",
                price: ["The Walking Dead", "Insidious", "Conjuring"],
                expand: false)
    ]
    
    var selectIndexPath: IndexPath!
    override func awakeFromNib() {
        data.append(Record(id: 1, name: "Huyen", price: 200))
        data.append(Record(id: 2, name: "Huyen2", price: 200))
        data.append(Record(id: 3, name: "Huyen3", price: 200))
        data.append(Record(id: 4, name: "Huyen4", price: 200))
        data.append(Record(id: 5, name: "Huyen5 Huyen5 Huyen5 Huyen5 Huyen5 Huyen5 Huyen5", price: 200))
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp.png")!)

        let leftController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenu")
        self.leftViewController = leftController
        
        super.awakeFromNib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self

    
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//            
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
        
        selectIndexPath = IndexPath(row: -1, section: -1)
        let nib = UINib(nibName: "ExpandableHeaderView", bundle: nil)
        mainTable.register(nib, forHeaderFooterViewReuseIdentifier: "expandableHeaderView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToLogin(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("ddd")
//        if (data.isEmpty) {
//            return 0
//        }
//        return data.count
        return sections[section].price.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
//        cell.lblPrice.text = String(describing: sections[indexPath.row].price_right)
        cell.lblPrice.text = sections[indexPath.row].date
        cell.lblName.text = String(describing: sections[indexPath.section].price[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if (data.isEmpty) {
//            return 0
//        }
//        return data.count
        return sections.count
    }
    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
//        headerView.customInit(date: sections[index].date, price_right: sections[index].price_right, section: index, delegate: self)
//        print("hêleee:"+"\(headerView.lbName.text!)")
//        return index
//    }
//
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
        headerView.customInit(date: sections[section].date, price_right: sections[section].price_right, section: section, delegate: self)
        print("hêleee:"+"\(headerView.lbPrice.text!)")
        return headerView.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        self.sections[section].expand = !self.sections[section].expand
        mainTable.beginUpdates()
        mainTable.reloadSections([section], with: .automatic)
        mainTable.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndexPath = indexPath
        self.sections[indexPath.section].expand = !self.sections[indexPath.section].expand
        tableView.beginUpdates()
        tableView.reloadSections([indexPath.section], with: .automatic)
        tableView.endUpdates()
    }
    

    
}

