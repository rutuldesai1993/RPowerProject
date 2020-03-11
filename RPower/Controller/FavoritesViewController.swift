//
//  FavoritesViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseClassController, UITableViewDelegate, UITableViewDataSource {
    
    var rest = RestManager()
    var rowsToDisplay:FavoriteDeeds?
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsToDisplay?.TasksList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableCell") as! PointsTableViewCell
        cell.descriptionLabel.text = rowsToDisplay?.TasksList[indexPath.row].Task
        cell.backgroundColor = UIColor.clear
        let image = UIImage(named: "favorites.png") as UIImage?
        cell.addFavoritesButton.setImage(image, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorites()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "Username") as! String
        let nib = UINib(nibName: "PointsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PointsTableCell")
        
        guard let url2 = URL(string: URLStrings.GET_FAVORITE_TASKS) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "Username")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(FavoriteDeeds.self,from:data)
                self.rowsToDisplay = pointsData
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
    func getFavorites() {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "Username") as! String
        guard let url2 = URL(string: URLStrings.GET_FAVORITE_TASKS) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "Username")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(FavoriteDeeds.self,from:data)
                self.rowsToDisplay = pointsData
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
