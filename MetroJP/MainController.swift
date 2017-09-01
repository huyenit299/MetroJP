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

protocol DateSelectedProtocol {
    func getDateSelected (date: String, id: Int)//id of row
}

var changedData = false
class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, FloatyDelegate {

    var fab = Floaty()
    @IBOutlet weak var mainTable: UITableView!
//    var data = [Record]();
    var row = -1 //row selecting
    
    var listRecord = Array<DateSection>()
    var listRecordTraffic: Array<RecordTrafficModel> = []
    
    var selectIndexPath: IndexPath!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("back e=" + String(changedData))
        if (changedData) {
            self.initData()
            self.mainTable.reloadData()
            changedData = false
        }
    }
    
    //check this month exist or not in list date section
    func checkMonthExist(record: RecordTrafficModel, list: Array<DateSection>) ->  Int {
        if (!list.isEmpty) {
            let recordMonth = Utils.convertStringDateToStringDate(formatFromStyle: Constant.DATE_STANDARD, formatToStyle: Constant.MONTH_YEAR_STANDARD, dateString: record.date)
            var cursor = 0
            for item in list {
                if recordMonth == item.month {
                   return cursor
                }
                cursor = cursor + 1
            }
        }
        return -1
    }
    
    func initPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        mainTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            print("pull to refresh")
            self?.initData()
            self?.mainTable.reloadData()
            // Do not forget to call dg_stopLoading() at the end
            self?.mainTable.dg_stopLoading()
            }, loadingView: loadingView)
        mainTable.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        mainTable.dg_setPullToRefreshBackgroundColor(mainTable.backgroundColor!)
    }
    
    func initData() {
        listRecord.removeAll()
        listRecordTraffic = DatabaseManagement.shared.queryAllRecordTraffic()
        if (!listRecordTraffic.isEmpty) {
            for item in listRecordTraffic {
                var list: Array<RecordTrafficModel> = []
                let position = checkMonthExist(record: item, list: listRecord)
                print("position =" + String(position))
                if (position == -1) {//not existed yet
                    list.append(item)
                    let dateSection = DateSection(month: Utils.convertStringDateToStringDate(formatFromStyle: Constant.DATE_STANDARD, formatToStyle: Constant.MONTH_YEAR_STANDARD, dateString: item.date), totalPrice: item.price, list: list)
                    listRecord.append(dateSection)
                } else {
                    list = listRecord[position].list as! Array<RecordTrafficModel>
                    list.append(item)
                    let price = Int(item.price)
                    let totalPrice = Int(listRecord[position].totalPrice)! + price!
                    listRecord[position].totalPrice = String(totalPrice)
                    listRecord[position].list = list
                }
            }
        }
    }
    
    var count = 0
    func menuButtonTapped() {
        print("aaaab right")
        self.title = "" + String(count)
        count = count + 1
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp.png")!)
        self.title = "交通費"
        self.addRightBarButtonWithImage(UIImage(named: "ic_cloud_upload_white_48pt")!)
        self.navigationItem.rightBarButtonItem?.action = #selector(menuButtonTapped)
        
        layoutFAB()
        
//        listRecord = ParseJson().readJson()
        
        initData()
        
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
        
        
        initPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToLogin(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listRecord[section].list.isEmpty) {
            return 0
        }
        return listRecord[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
        cell.lblPrice.text = listRecord[indexPath.section].list[indexPath.row]?.price
        cell.lblName.text = listRecord[indexPath.section].list[indexPath.row]?.target
        cell.lblId.text = listRecord[indexPath.section].list[indexPath.row]?.date

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!listRecord[indexPath.section].expand) {
            return 44
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (listRecord.isEmpty) {
            return 0
        }
        return listRecord.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("hello")
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
         headerView.customInit(date: listRecord[section].month, price_right: listRecord[section].totalPrice, section: section, delegate: self)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        self.listRecord[section].expand = !self.listRecord[section].expand
        mainTable.beginUpdates()
        mainTable.reloadSections([section], with: .none)
        mainTable.endUpdates()
    }
    
    func clickMore(section: Int) {
        let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clickAdd(section: Int, month: String) {
        print("add new")
        let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndexPath = indexPath
        row = indexPath.row
        let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        scr.id = (listRecord[indexPath.section].list[indexPath.row]?.id)!
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            let alert = UIAlertController(title: "", message: "削除しますよろしいですか", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キアソセル", style: .default,
            handler: {(alert:UIAlertAction!) in
                tableView.setEditing(false, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                    if DatabaseManagement.shared.deleteRecordTraffic(trafficId: Int64(self.listRecord[indexPath.section].list[indexPath.row]!.id)) {
                        self.listRecord[indexPath.section].list.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDateSelected (date: String, id: Int) {
        
        
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
            alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: { (item) in
                let alert = UIAlertController(title: "titlePosition nil", message: "titlePosition nil will be left", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok...", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.fab.close()
                }
))
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
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "Favorite") as! FavoriteViewController
            self.present(scr, animated: true, completion: nil)
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

        let addRecord = FloatyItem()
        addRecord.buttonColor = UIColor.blue
        addRecord.circleShadowColor = UIColor.red
        addRecord.titleShadowColor = UIColor.blue
        addRecord.title = "Add new record"
        addRecord.icon = UIImage(named: "ic_add_circle_outline_white")
        addRecord.handler = { (item) in
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
            self.navigationController?.pushViewController(scr, animated: true)
        }
        
        fab.addItem(item: addRecord)
        fab.addItem(item: itemRating)
        fab.addItem(item: itemSearch)
        fab.addItem(item: itemUpload)
        fab.sticky = true
        fab.paddingX = fab.frame.width/2
        
        fab.fabDelegate = self
        
        self.view.addSubview(fab)
    }
}

