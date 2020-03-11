//
//  MostRecentViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class MostRecentViewController: BaseClassController, UITableViewDataSource, UITableViewDelegate {
    var rest = RestManager()
    var rowsToDisplayDeeds:[RecentDeeds]?
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplayDeeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = rowsToDisplayDeeds![indexPath.row].deed
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    override func viewDidLoad() {
       super.viewDidLoad()
       self.title = "Most Recent"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear

       let defaults = UserDefaults.standard
       let username = defaults.object(forKey: "Username") as! String
       
        guard let url2 = URL(string: URLStrings.GET_RECENT_DEEDS) else { return }
       rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
       rest.httpBodyParameters.add(value:username , forKey: "Username")
       rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
           if let data = results.data {
            do{
                let pointsData = try JSONDecoder().decode([RecentDeeds].self,from:data)
                self.rowsToDisplayDeeds = pointsData
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
            }
            catch let JSONErr{
                print(JSONErr)
            }
           }
       }
    }
}
