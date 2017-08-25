//
//  CreateNewRecordControllerViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/24/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class CreateNewRecordControllerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var listStations: Array<Station> = []
    
    @IBOutlet weak var tableStation: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New title"
        let station1 = Station(id: 1, name: "JR", select: false)
        let station2 = Station(id: 1, name: "地下鉄", select: false)
        let station3 = Station(id: 1, name: "私鉄", select: false)
        let station4 = Station(id: 1, name: "高速", select: false)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        tableStation.dataSource = self
        tableStation.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StationItemView = tableView.dequeueReusableCell(withIdentifier: "StationItemView") as! StationItemView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }


}
