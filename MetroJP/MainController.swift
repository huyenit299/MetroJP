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
import Floaty

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, FloatyDelegate {
    var fab = Floaty()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp.png")!)
        layoutFAB()
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
        if (sections[section].price.isEmpty) {
            return 0
        }
        return sections[section].price.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
        cell.lblPrice.text = sections[indexPath.row].date
        cell.lblName.text = String(describing: sections[indexPath.section].price[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (sections.isEmpty) {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
        headerView.customInit(date: sections[section].date, price_right: sections[section].price_right, section: section, delegate: self)
        return headerView
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
    
    //layout fload a button
    func layoutFAB() {
        let itemSearch = FloatyItem()
        itemSearch.buttonColor = UIColor.blue
        itemSearch.circleShadowColor = UIColor.red
        itemSearch.titleShadowColor = UIColor.blue
        itemSearch.title = "検索"
        itemSearch.icon = UIImage(named: "ic_search_white_48pt")
        itemSearch.handler = { (item) in
            let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.fab.close()
        }
        
        
        let itemRating = FloatyItem()
        itemRating.buttonColor = UIColor.blue
        itemRating.circleShadowColor = UIColor.red
        itemRating.titleShadowColor = UIColor.blue
        itemRating.title = "お気に入り"
        itemRating.icon = UIImage(named: "ic_star_border_white_48dp")
        itemRating.handler = { (item) in
            let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.fab.close()
        }
        
        let itemUpload = FloatyItem()
        itemUpload.buttonColor = UIColor.blue
        itemUpload.circleShadowColor = UIColor.red
        itemUpload.titleShadowColor = UIColor.blue
        itemUpload.title = "アップロード"
        itemUpload.icon = UIImage(named: "ic_cloud_upload_white_48pt")
        itemUpload.handler = { (item) in
            let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.fab.close()
        }
        
//        fab.addItem("お気に入り", icon: UIImage(named: "ic_star_border_white_48dp"))
//
//        fab.addItem("検索", icon: UIImage(named: "ic_search_white_48pt"), titlePosition: nil) { (item) in
//            let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            self.fab.close()
//        }
//        fab.addItem("アップロード", icon: UIImage(named: "ic_cloud_upload_white_48pt")) { item in
//            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            self.fab.close()
//        }
        fab.addItem(item: itemRating)
        fab.addItem(item: itemSearch)
        fab.addItem(item: itemUpload)
        fab.sticky = true
        fab.paddingX = fab.frame.width/2
        
        fab.fabDelegate = self
        
        self.view.addSubview(fab)
    }
}

