//
//  PointsViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class AddPointsViewController: BaseClassController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        print ("index: ", sender.selectedSegmentIndex)

        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 0
            self.rowsToDisplay = pointsTable
            tableView.reloadData()
        }

        if sender.selectedSegmentIndex == 1 {
            selectedSegment = 1
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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var pointsTable = [PointsTable]()
    var selectedSegment: Int = 0
    var pointsRecentDeedsTable = [RecentDeeds]()
    var rest = RestManager()
    var rowsToDisplay = [PointsTable]()
    var rowsToDisplayDeeds = [RecentDeeds]()
    var rowsToDisplayFavorites:FavoriteDeeds?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegment == 0{
            return self.rowsToDisplay.count
        }
        else
        {
            return self.rowsToDisplayDeeds.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableCell") as! PointsTableViewCell
        cell.backgroundColor = UIColor.clear
        getFavorites()
        if selectedSegment == 0
        {
            cell.descriptionLabel.text = self.rowsToDisplay[indexPath.row].Description
            cell.addPointsButton.isHidden = false
            cell.cellDelegate = self
            cell.index = indexPath
            let arrFilter = self.rowsToDisplayFavorites?.TasksList.filter{(arrOfOpration) -> Bool in
                arrOfOpration.Task == self.rowsToDisplay[indexPath.row].Description
            }
            if (arrFilter?.count ?? 0)>0 {
                let image = UIImage(named: "favorites.png") as UIImage?
                cell.addFavoritesButton.setImage(image, for: .normal)
            }
            else{
                let image = UIImage(named: "NoFavorite.png") as UIImage?
                cell.addFavoritesButton.setImage(image, for: .normal)
            }
            return cell
        }
        else
        {
            cell.descriptionLabel?.text = self.rowsToDisplayDeeds[indexPath.row].deed
            cell.addPointsButton.isHidden = true
            cell.addFavoritesButton.isHidden = false
            cell.cellDelegate = self
            cell.index = indexPath
            let arrFilter = self.rowsToDisplayFavorites?.TasksList.filter{(arrOfOpration) -> Bool in
                arrOfOpration.Task == self.rowsToDisplayDeeds[indexPath.row].deed
            }
            if (arrFilter?.count ?? 0)>0 {
                let image = UIImage(named: "favorites.png") as UIImage?
                cell.addFavoritesButton.setImage(image, for: .normal)
            }
            else{
                let image = UIImage(named: "NoFavorite.png") as UIImage?
                cell.addFavoritesButton.setImage(image, for: .normal)
            }
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorites()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Points"
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.selectedSegmentTintColor = UIColor.black
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.cornerRadius = 3.0
        segmentedControl.layer.borderColor = UIColor.black.cgColor
        let nib = UINib(nibName: "PointsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PointsTableCell")
        
        guard let url = URL(string: URLStrings.POINTS_TABLE) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
           if let data = results.data {
            do{
                let pointsData = try JSONDecoder().decode([PointsTable].self,from:data)
                self.pointsTable = pointsData
                if(self.selectedSegment == 0)
                {
                    self.rowsToDisplay = pointsData
                }
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

extension AddPointsViewController: AddPointsView{
    func onAddingPoints(index: Int) {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "Username") as! String
        guard let url2 = URL(string: URLStrings.ADD_DEEDS) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "user")
        rest.httpBodyParameters.add(value:rowsToDisplay[index].Description! , forKey: "deed")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd h:mm:ss a"
        let formattedDate = format.string(from: date)
        rest.httpBodyParameters.add(value: formattedDate, forKey: "date")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                if pointsData.Result == "Deed added successfully"
                {
                    DispatchQueue.main.async {
                        let alert2 = UIAlertController(title: "Points Added", message: nil, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                            alert2!.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert2, animated: true)
                    }
                }
             }
             catch let JSONErr{
                 print(JSONErr)
             }
            }
        }
    }
    
    func onAddFavorites(index: Int) {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "Username") as! String
        var isFavorite = 1
        
        let arrFilter = self.rowsToDisplayFavorites!.TasksList.filter{(arrOfOpration) -> Bool in
            arrOfOpration.Task == self.rowsToDisplay[index].Description
        }
        if (arrFilter.count )>0 {
            isFavorite = 0
        }
        else{
            isFavorite = 1
        }
        
        guard let url2 = URL(string: "http://www.consoaring.com/PointService.svc/setfavoritetask") else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "Username")
        rest.httpBodyParameters.add(value:isFavorite , forKey: "IsFavorite")
        rest.httpBodyParameters.add(value:rowsToDisplay[index].Description! , forKey: "Task")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                if pointsData.Result == "Favorite task set"
                {
                    self.getFavorites()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        var title = ""
                        switch isFavorite{
                        case 0:
                            title = "Favorite Removed"
                            break
                        case 1:
                            title = "Favorite Added"
                            break
                        default:
                            title = "Favorite Added"
                            break
                        }
                        let alert2 = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                            alert2!.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert2, animated: true)
                        
                    }
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
        guard let url2 = URL(string: "http://www.consoaring.com/PointService.svc/getfavoritetasks") else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "Username")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(FavoriteDeeds.self,from:data)
                self.rowsToDisplayFavorites = pointsData
             }
             catch let JSONErr{
                 print(JSONErr)
             }
            }
        }
    }
}
