//
//  AddFriendViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class AddFriendViewController: BaseClassController, UITableViewDelegate, UITableViewDataSource {
    var selectedSegment: Int = 0
    var FriendRequestResponded: [Bool]?
    var rowsToDisplayFriendsList:Friends?
    var rowsToDisplayFriendRequestList:FriendRequest?
    var rest = RestManager()
    let defaults = UserDefaults.standard
    
    @objc func callPlusMethod() {
        let alert = UIAlertController(title: "RPower", message: "Send Request", preferredStyle: .alert)
        let username = defaults.object(forKey: "Username") as! String

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let url2 = URL(string: URLStrings.ADD_FRIEND_REQUESTS) else { return }
            self.rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            self.rest.httpBodyParameters.add(value:username , forKey: "Sender")
            self.rest.httpBodyParameters.add(value:textField!.text! , forKey: "Reciever")
            self.rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                if let data = results.data {
                 do{
                     let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                    if pointsData.Result == "Request sent."
                    {
                        DispatchQueue.main.async {
                            let alert2 = UIAlertController(title: "Request Sent", message: nil, preferredStyle: .alert)
                            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                                alert2!.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert2, animated: true)
                        }
                    }
                    else if(pointsData.Result == "Invalid Username!")
                    {
                        DispatchQueue.main.async {
                            let alert2 = UIAlertController(title: "Invalid Username!", message: nil, preferredStyle: .alert)
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
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 0
            let username = defaults.object(forKey: "Username") as! String
            guard let url2 = URL(string: URLStrings.GET_FRIENDS_LIST) else { return }
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:username , forKey: "Username")
            rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                if let data = results.data {
                 do{
                     let pointsData = try JSONDecoder().decode(Friends.self,from:data)
                     self.rowsToDisplayFriendsList = pointsData
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

        if sender.selectedSegmentIndex == 1 {
            selectedSegment = 1
            let username = defaults.object(forKey: "Username") as! String
            
            guard let url2 = URL(string: URLStrings.GET_FRIEND_REQUESTS) else { return }
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:username , forKey: "Username")
            rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                if let data = results.data {
                 do{
                     let pointsData = try JSONDecoder().decode(FriendRequest.self,from:data)
                     self.rowsToDisplayFriendRequestList = pointsData
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case 0:
            return rowsToDisplayFriendsList?.Friends.count ?? 0
        case 1:
            return (rowsToDisplayFriendRequestList?.Requests?.count ?? 0)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegment {
        case 0:
            let cell = UITableViewCell()
            cell.textLabel?.text = rowsToDisplayFriendsList?.Friends[indexPath.row].Username
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestTableViewCell", for: indexPath) as! FriendRequestTableViewCell
            cell.cellDelegate = self
            cell.index = indexPath
            if self.FriendRequestResponded?[indexPath.row] ?? false {
                cell.isHidden = true
            }
            guard (rowsToDisplayFriendRequestList?.Requests) != nil else {
                return UITableViewCell()
            }
            
            cell.usernameLbl?.text = rowsToDisplayFriendRequestList!.Requests![indexPath.row].Username
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegment == 0{
            let reciever = self.rowsToDisplayFriendsList!.Friends[indexPath.row]
            self.defaults.set(reciever.Username, forKey: "Reciever")
           performSegue(withIdentifier: "ChatViewController", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Friends"
        tableView.backgroundColor = UIColor.clear
        segmentedControl.selectedSegmentTintColor = UIColor.black
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.cornerRadius = 3.0
        segmentedControl.layer.borderColor = UIColor.black.cgColor
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action:#selector(callPlusMethod), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
        
        
        let nib = UINib(nibName: "FriendRequestTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendRequestTableViewCell")
        let username = defaults.object(forKey: "Username") as! String
        guard let url2 = URL(string: URLStrings.GET_FRIENDS_LIST) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:username , forKey: "Username")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(Friends.self,from:data)
                 self.rowsToDisplayFriendsList = pointsData
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
extension AddFriendViewController: AddFriendsView{
    func onRejectingRequest(index: Int) {
        let username = defaults.object(forKey: "Username") as! String
        guard let url2 = URL(string: URLStrings.RESPOND_FRIEND_REQUESTS) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: self.rowsToDisplayFriendRequestList!.Requests![index].Username! , forKey: "Sender")
        rest.httpBodyParameters.add(value:username, forKey: "Reciever")
        rest.httpBodyParameters.add(value:0, forKey: "Status")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                DispatchQueue.main.async {
                    if pointsData.Result == "Friend request Declined."
                    {
                        self.FriendRequestResponded?[index] = true
                        self.tableView.reloadData()
                        let alert2 = UIAlertController(title: "Friend request Declined.", message: nil, preferredStyle: .alert)
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
    
    func onAcceptingRequest(index: Int) {
        let username = defaults.object(forKey: "Username") as! String
        guard let url2 = URL(string: URLStrings.RESPOND_FRIEND_REQUESTS) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:self.rowsToDisplayFriendRequestList!.Requests![index].Username! , forKey: "Sender")
        rest.httpBodyParameters.add(value:username , forKey: "Reciever")
        rest.httpBodyParameters.add(value:2, forKey: "Status")
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                DispatchQueue.main.async {
                    if pointsData.Result == "Friend request Accepted."
                    {
                            self.FriendRequestResponded?[index] = true
                        self.tableView.reloadData()
                        let alert2 = UIAlertController(title: "Friend request Accepted.", message: nil, preferredStyle: .alert)
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
}
