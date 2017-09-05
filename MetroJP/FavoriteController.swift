//
//  FavoriteController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/1/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    var myList = Array<Destination>();
    var sharedList = Array<Destination>();
    var selectingtab = Constant.MY_LIST
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableFavorite: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSearching = Array<Destination>()
    var isSearching: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "お気に入り"
        navigationItem.leftBarButtonItem?.title = "Back"
        
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        myList = DatabaseManagement.shared.queryAllDestination(_type: Constant.MY_LIST)
        self.tableFavorite.dataSource = self
        self.tableFavorite.delegate = self
        searchBar.delegate = self
        segmentController.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        
    }
    
    func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        selectingtab = sender.selectedSegmentIndex
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case Constant.MY_LIST:
            if (myList.isEmpty) {
                myList = DatabaseManagement.shared.queryAllDestination(_type: Constant.MY_LIST)
            }
            break
        case Constant.SHARED_LIST:
            if (sharedList.isEmpty) {
                sharedList = DatabaseManagement.shared.queryAllDestination(_type: Constant.SHARED_LIST)
            }
            break
        default:
            break
        }
        tableFavorite.reloadData()
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
            cell.lbName.text = dataSearching[indexPath.row].name
        } else {
            switch selectingtab {
            case Constant.MY_LIST:
                cell.lbName.text = myList[indexPath.row].name
                break
            case Constant.SHARED_LIST:
                cell.lbName.text = sharedList[indexPath.row].name
                break
            default:
                break
            }
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
                var destinationId = -1
                switch self.selectingtab {
                case Constant.MY_LIST:
                    destinationId = Int(self.myList[indexPath.row].id)
                    break
                case Constant.SHARED_LIST:
                    destinationId = Int(self.sharedList[indexPath.row].id)
                    break
                default:
                    break
                }

                if DatabaseManagement.shared.deleteDestination(destinationId: Int64(destinationId)){
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
    
    func filterTableView(ind:Int,text:String) {
        switch ind {
        case Constant.MY_LIST:
            //fix of not searching when backspacing
            dataSearching = myList.filter({ (mod) -> Bool in
                return mod.name.lowercased().contains(text.lowercased())
            })
            self.tableFavorite.reloadData()
        case Constant.SHARED_LIST:
            //fix of not searching when backspacing
            dataSearching = sharedList.filter({ (mod) -> Bool in
                return mod.name.lowercased().contains(text.lowercased())
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
}
