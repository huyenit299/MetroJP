//
//  SearchViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/6/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tablePlace: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSearching = Array<RecordTrafficModel>()
    var data = Array<RecordTrafficModel>()
    var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "検索"
        data = DatabaseManagement.shared.queryAllRecordTraffic()
        tablePlace.dataSource = self
        tablePlace.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return dataSearching.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchItemTableViewCell
        if (isSearching) {
            cell.lbSearchItem.text = dataSearching[indexPath.row].target
        } else {
            cell.lbSearchItem.text = data[indexPath.row].target
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let update = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("update")
        }
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            let alert = UIAlertController(title: "", message: "削除しますよろしいですか", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キアソセル", style: .default,
                                          handler: {(alert:UIAlertAction!) in
                                            tableView.setEditing(false, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                if (self.isSearching) {
                    if DatabaseManagement.shared.deleteRecordTraffic(trafficId: self.dataSearching[indexPath.row].id){
                        self.dataSearching.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                } else {
                    if DatabaseManagement.shared.deleteRecordTraffic(trafficId: self.data[indexPath.row].id){
                        self.data.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return [delete, update]
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
    
    func filterTableView(text:String) {
        dataSearching = data.filter({ (mod) -> Bool in
            return mod.target.lowercased().contains(text.lowercased())
        })
        self.tablePlace.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "") {
            isSearching = false
            view.endEditing(true)
            tablePlace.reloadData()
        } else {
            isSearching = true
            filterTableView(text: searchBar.text!)
        }
    }
}
