//
//  StationViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var listStations: Array<Station> = []

    @IBOutlet weak var tfTarget: UITableView!
    @IBOutlet weak var tfDate: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tableStation: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableStation.register(nib, forCellReuseIdentifier: "TrafficItemView")

        
        tableStation.dataSource = self
        tableStation.delegate = self


    }

    func initData() {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficItemView") as! TrafficItemView
        cell.lbStation.text = "label " + String(indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select="+String(indexPath.row))
    }

}
