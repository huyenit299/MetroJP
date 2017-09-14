//
//  MainController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/9/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Floaty
import CoreData
import Foundation



var changedData = false
class MainController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, FloatyDelegate, SessionListDelegate, ChangeMonthDelegate {

    var fab = Floaty()
    @IBOutlet weak var mainTable: UITableView!
//    var data = [Record]();
    var row = -1 //row selecting
    
    var listRecord = Array<DateSection>()
    var listRecordTraffic: Array<RecordTrafficModel> = []
    
    var selectIndexPath: IndexPath!
    var tableView: UITableView!
    // create the concurrent queue
    let asyncQueue = DispatchQueue(label: "loadSession", attributes: .concurrent)
    
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
            self?.loadData()
            self?.mainTable.dg_stopLoading()
            }, loadingView: loadingView)
        mainTable.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        mainTable.dg_setPullToRefreshBackgroundColor(mainTable.backgroundColor!)
    }
    
    func getToken() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for res in result as! [NSManagedObject] {
                    if let token = res.value(forKey: "token") as? String {
                        print("return token-" + token)
                        return token
                    }
                }
            }
        }
        catch {
            print(error)
        }
        return ""
    }
    
    func initData() {
        listRecord.removeAll()
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
        self.loading.hideActivityIndicator(uiView: self.view)
        self.mainTable.reloadData()
        self.mainTable.endUpdates()
    }

    
    func menuButtonTapped() {
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "ExportController") as! ExportController
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    //load data from local if no internet connection, else load from API
    func loadData() {
        if ((self.manager?.isReachable)!) {
            self.asyncQueue.async {
                self.loading.showActivityIndicator(uiView: self.view)
                WebservicesHelper.getListMonth()
                WebservicesHelper.getListSession(sessionDelegate: self)
            }
        } else {
           
               self.loading.showActivityIndicator(uiView: self.view)
                self.listRecordTraffic = DatabaseManagement.shared.queryAllRecordTraffic()
//                DispatchQueue.main.async {
                    self.initData()
//                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp.png")!)
        self.title = "交通費"
        self.addRightBarButtonWithImage(UIImage(named: "ic_cloud_upload_white_48pt")!)
        self.navigationItem.rightBarButtonItem?.action = #selector(menuButtonTapped)
        
        layoutFAB()

        loadData()

        mainTable.dataSource = self
        mainTable.delegate = self

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
        if tableView == self.mainTable{
            if (listRecord[section].list.isEmpty) {
                return 0
            }
            return listRecord[section].list.count
        }
        else {
            return listRecord.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mainTable{
            let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainTableViewCell
            cell.lblPrice.text = listRecord[indexPath.section].list[indexPath.row]?.price
            cell.lblName.text = listRecord[indexPath.section].list[indexPath.row]?.target
            cell.lblId.text = listRecord[indexPath.section].list[indexPath.row]?.date
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficItemView") as! TrafficItemView
            cell.lbStation.text = listRecord[indexPath.row].month
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!listRecord[indexPath.section].expand) {
            return 44
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.mainTable{
            if (listRecord.isEmpty) {
                return 0
            }
            return listRecord.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("hello")
        if (tableView == self.mainTable) {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
         headerView.customInit(date: listRecord[section].month, price_right: listRecord[section].totalPrice, section: section, delegate: self)
//         listRecord[section].x = headerView.btnMore.frame.origin.x
//         listRecord[section].y = headerView.btnMore.frame.origin.y
        return headerView
        }  else {
            return UIView()
        }
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
        let popOverVC = storyboard?.instantiateViewController(withIdentifier: "PopupMonthViewController") as! PopupMonthViewController
        self.addChildViewController(popOverVC)
        let rect = CGRect(x: 20, y: 100, width: Int(popOverVC.view.bounds.size.width - 80), height: Int(44 * (listRecord.count + 1)))
//        let rect =  CGRect(x: x, y: y, width: popOverVC.view.bounds.size.width - 80, height: CFloat(100))
        popOverVC.view.frame = rect
        popOverVC.delegate = self
        popOverVC.listRecord = listRecord
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    func clickAdd(section: Int, month: String) {
        print("add new")
        let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.mainTable{
            self.selectIndexPath = indexPath
            row = indexPath.row
            let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
            scr.id = (listRecord[indexPath.section].list[indexPath.row]?.id)!
            self.navigationController?.pushViewController(scr, animated: true)
        } else {
            print("dddd")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let copy = UITableViewRowAction(style: .destructive, title: "複製") { action, index in
            print("copy")
            let record = self.listRecord[indexPath.section].list[indexPath.row]!
            WebservicesHelper.addSession(date: record.date, target: record.target, traffic: record.traffic, from: record.from, to: record.to, fare: record.price, remarks: record.note)
            if (DatabaseManagement.shared.addRecordTraffic(record: self.listRecord[indexPath.section].list[indexPath.row]!)! > 0 ) {
                self.initData()
                self.mainTable.reloadData()
            }
        }
        copy.backgroundColor = UIColor.gray
        
        // お気に入りに追加
        let addToFavorite = UITableViewRowAction(style: .normal, title: "お気に入りに追加") { action, index in
            print("addToFavorite")
            let record = self.listRecord[indexPath.section].list[indexPath.row]
            record?.isFavorite = 1
            WebservicesHelper.addFavorite(sessionId: self.listRecord[indexPath.section].list[indexPath.row]!.id, common: true)
            if (DatabaseManagement.shared.updateRecordTraffic(trafficId: Int((self.listRecord[indexPath.section].list[indexPath.row]?.id)!), newTraffic: record!)) {
                self.listRecord[indexPath.section].list[indexPath.row] = record
                tableView.setEditing(false, animated: true)
            }
        }
        addToFavorite.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .default, title: "削除") { action, index in
            let alert = UIAlertController(title: "", message: "削除しますよろしいですか", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キアソセル", style: .default,
                                          handler: {(alert:UIAlertAction!) in
                                            tableView.setEditing(false, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                WebservicesHelper.deleteSession(sessionId: self.listRecord[indexPath.section].list[indexPath.row]!.id)
                if DatabaseManagement.shared.deleteRecordTraffic(trafficId: self.listRecord[indexPath.section].list[indexPath.row]!.id) {
                    self.listRecord[indexPath.section].list.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (self.listRecord[indexPath.section].list[indexPath.row]?.isFavorite == 0) {
            return [delete, addToFavorite, copy]
        } else {
            return [delete, copy]
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
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            self.navigationController?.pushViewController(scr, animated: true)
        }
        
        
        let itemRating = FloatyItem()
        itemRating.buttonColor = UIColor.blue
        itemRating.circleShadowColor = UIColor.red
        itemRating.titleShadowColor = UIColor.blue
        itemRating.title = "お気に入り"
        itemRating.icon = UIImage(named: "ic_star_border_white_48dp")
        itemRating.handler = { (item) in
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteController") as! FavoriteController
            self.navigationController?.pushViewController(scr, animated: true)
        }
        
        let itemUpload = FloatyItem()
        itemUpload.buttonColor = UIColor.blue
        itemUpload.circleShadowColor = UIColor.red
        itemUpload.titleShadowColor = UIColor.blue
        itemUpload.title = "アップロード"
        itemUpload.icon = UIImage(named: "ic_cloud_upload_white_48pt")
        itemUpload.handler = { (item) in
            let scr = self.storyboard?.instantiateViewController(withIdentifier: "ExportController") as! ExportController
            self.navigationController?.pushViewController(scr, animated: true)
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
    
    //delegate session list
    func getSessionList (listRecordTraffic: Array<RecordTrafficModel>) {
        if (listRecordTraffic.isEmpty) {
            self.loading.hideActivityIndicator(uiView: self.view)
        }
        DispatchQueue.main.async {
            self.listRecordTraffic = listRecordTraffic
            self.initData()
        }
    }
    
    func changeMonth (month: String) {
        print("AAAAA-" + month)
        WebservicesHelper.getListSession(sessionDelegate: self, month: month)
    }
}

