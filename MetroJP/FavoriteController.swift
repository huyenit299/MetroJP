//
//  FavoriteController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/1/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

protocol FavoriteDelegate {
    func getListFavorite(listFavorite: Array<FavoriteModel>)
}

class FavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FavoriteDelegate{
    var myList = Array<FavoriteModel>();
    var sharedList = Array<FavoriteModel>();
    var selectingtab = Constant.MY_LIST
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableFavorite: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSearching = Array<FavoriteModel>()
    var isSearching: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "お気に入り"
        navigationItem.leftBarButtonItem?.title = "Back"
        
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        
        myList = DatabaseManagement.shared.queryAllFavorite(type: Constant.MY_LIST)
        
        WebservicesHelper.getListFavorite(delegate: self, type: selectingtab)

        self.tableFavorite.dataSource = self
        self.tableFavorite.delegate = self
        searchBar.delegate = self
        segmentController.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        
    }
    
    func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        selectingtab = sender.selectedSegmentIndex
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
//        switch sender.selectedSegmentIndex {
//        case Constant.MY_LIST:
//            if (myList.isEmpty) {
//                myList = DatabaseManagement.shared.queryAllFavorite(type: Constant.MY_LIST)
//            }
//            break
//        case Constant.SHARED_LIST:
//            if (sharedList.isEmpty) {
//                sharedList = DatabaseManagement.shared.queryAllFavorite(type: Constant.SHARED_LIST)
//            }
//            break
//        default:
//            break
//        }
//        tableFavorite.reloadData()
         WebservicesHelper.getListFavorite(delegate: self, type: selectingtab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return dataSearching.count
        } else {
        switch selectingtab {
        case Constant.MY_LIST:
            return myList.count
        case Constant.SHARED_LIST:
            return sharedList.count
        default:
            return 0
        }
      }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FavoriteTableViewCell
        if (isSearching) {
            cell.lbName.text = dataSearching[indexPath.row].target
        } else {
            switch selectingtab {
            case Constant.MY_LIST:
                cell.lbName.text = myList[indexPath.row].target
                break
            case Constant.SHARED_LIST:
                cell.lbName.text = sharedList[indexPath.row].target
                break
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectingtab {
        case Constant.MY_LIST:
            if (!myList.isEmpty) {
                let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
                scr.id = self.myList[indexPath.row].id
                self.navigationController?.pushViewController(scr, animated: true)
            }
            break
        case Constant.SHARED_LIST:
            if (!sharedList.isEmpty) {
                let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
                scr.id = self.sharedList[indexPath.row].id
                self.navigationController?.pushViewController(scr, animated: true)
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            let alert = UIAlertController(title: "", message: "削除しますよろしいですか", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キアソセル", style: .default,
                                          handler: {(alert:UIAlertAction!) in
                                            var id = -1
                                            switch self.selectingtab {
                                            case Constant.MY_LIST:
                                                id = Int(self.myList[indexPath.row].id)
                                                break
                                            case Constant.SHARED_LIST:
                                                id = Int(self.sharedList[indexPath.row].id)
                                                break
                                            default:
                                                break
                                            }
                                            WebservicesHelper.deleteFavorite(favoriteId: id)
                                            tableView.setEditing(false, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                var id = -1
                var sessionId = -1
                var common = 0
                var record = FavoriteModel()
                switch self.selectingtab {
                case Constant.MY_LIST:
                    id = Int(self.myList[indexPath.row].id)
                    record = self.myList[indexPath.row]
                    sessionId = self.myList[indexPath.row].session_id
                    common = self.myList[indexPath.row].common
                    break
                case Constant.SHARED_LIST:
                    id = Int(self.sharedList[indexPath.row].id)
                    record = self.sharedList[indexPath.row]
                    sessionId = self.sharedList[indexPath.row].session_id
                    common = self.sharedList[indexPath.row].common
                    break
                default:
                    break
                }

               WebservicesHelper.updateFavorite(favoriteId: id, sessionId: sessionId, common: common)
                if DatabaseManagement.shared.updateFavorite(favoriteId: Int64(id), newTraffic: record){
                    switch self.selectingtab {
                    case Constant.MY_LIST:
                        self.myList.remove(at: indexPath.row)
                        break
                    case Constant.SHARED_LIST:
                        self.sharedList.remove(at: indexPath.row)
                        break
                    default:
                        break
                    }
                    tableView.reloadData()
                    changedData = true
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return [delete]
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func filterTableView(ind:Int,text:String) {
        switch ind {
        case Constant.MY_LIST:
            //fix of not searching when backspacing
            dataSearching = self.myList.filter({ (mod) -> Bool in
                return mod.target.lowercased().contains(text.lowercased())
            })
            self.tableFavorite.reloadData()
        case Constant.SHARED_LIST:
            //fix of not searching when backspacing
            dataSearching = self.sharedList.filter({ (mod) -> Bool in
                return mod.target.lowercased().contains(text.lowercased())
            })
            self.tableFavorite.reloadData()
        default:
            print("no type")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "") {
            isSearching = false
            view.endEditing(true)
            tableFavorite.reloadData()
        } else {
            isSearching = true
            filterTableView(ind: selectingtab, text: searchBar.text!)
        }
    }
    
    func getListFavorite(listFavorite: Array<FavoriteModel>) {
        switch selectingtab {
        case Constant.MY_LIST:
           myList = listFavorite
           break
        case Constant.SHARED_LIST:
            sharedList = listFavorite
            break
        default:
            break
        }
        tableFavorite.reloadData()
    }

}
