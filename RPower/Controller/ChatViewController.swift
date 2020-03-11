//
//  ChatViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messages: ChatMessages?
    let defaults = UserDefaults.standard
    var reciever = ""
    var username = ""
    let rest = RestManager()
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.Messages.count ?? 0
    }
    
    @IBOutlet weak var titleLbl: UINavigationItem!
    @IBOutlet weak var messageTxt: UITextField!
    @IBAction func sendMessageAction(_ sender: UIButton) {
        if messageTxt.text != "" {
            sendMessages()
        }
        else{
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reciever = defaults.object(forKey: "Reciever") as! String
        let cell = UITableViewCell()
        cell.textLabel?.text = messages?.Messages[indexPath.row].Message
        if messages?.Messages[indexPath.row].Sender?.uppercased() == reciever.uppercased()
        {
            cell.textLabel?.textAlignment = NSTextAlignment.left
        }
        else
        {
            cell.textLabel?.textAlignment = NSTextAlignment.right
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = defaults.object(forKey: "Reciever") as? String
        getMessages()
    }
    
    func getMessages(){
        self.reciever = defaults.object(forKey: "Reciever") as! String
        self.username = defaults.object(forKey: "Username") as! String
        let date: String = "1970/01/01 00:00:00"
        guard let url = URL(string: URLStrings.GET_MESSAGE) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:self.username, forKey: "Sender")
        rest.httpBodyParameters.add(value:self.reciever, forKey: "Reciever")
        rest.httpBodyParameters.add(value: date, forKey: "DateAndTime")
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(ChatMessages.self,from:data)
                self.messages = pointsData
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
    
    func sendMessages(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let formattedDate = format.string(from: date)
        guard let url = URL(string: URLStrings.SEND_MESSAGE) else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:self.username, forKey: "Sender")
        rest.httpBodyParameters.add(value:self.reciever, forKey: "Reciever")
        rest.httpBodyParameters.add(value: formattedDate, forKey: "DateAndTime")
        rest.httpBodyParameters.add(value: messageTxt.text ?? "", forKey: "Message")
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            if let data = results.data {
             do{
                 let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                if pointsData.Result == "Message Sent."{
                    self.getMessages()
                    DispatchQueue.main.async {
                    self.messageTxt.text = ""
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
