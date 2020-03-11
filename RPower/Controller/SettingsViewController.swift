    //
    //  SettingsViewController.swift
    //  RPower
    //
    //  Created by Rutul Desai on 2/24/20.
    //  Copyright © 2020 Rutul Desai. All rights reserved.
    //
    
    import UIKit
    import MessageUI
    
    class SettingsViewController: BaseClassController, UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        
        var user = User()
        var touchID = false
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Change Password"
                cell.backgroundColor = UIColor.clear
                return cell
            case 1:
                cell.textLabel?.text = "Report"
                cell.backgroundColor = UIColor.clear
                return cell
            case 2:
                cell.textLabel?.text = "Touch ID"
                cell.backgroundColor = UIColor.clear
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
                cell.accessoryView = switchView
                return cell
            default:
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
            }
            else if indexPath.row == 1 {
                sendEmail()
                let alert2 = UIAlertController(title: "Report is sent to your email.", message: nil, preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                    alert2!.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert2, animated: true)
            }
        }
        
        @objc func switchChanged(){
            let alert2 = UIAlertController(title: "Touch ID is updated", message: nil, preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                alert2!.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert2, animated: true)
        }
        
        
        @IBOutlet weak var tableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Settings"
            tableView.backgroundColor = UIColor.clear
            let rest = RestManager()
            let defaults = UserDefaults.standard
            let username = defaults.object(forKey: "Username") as! String
            
            let url2 = URL(string: URLStrings.GET_CURRENT_USER)!
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:username , forKey: "Username")
            rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                if let data = results.data {
                 do{
                     let pointsData = try JSONDecoder().decode(User.self,from:data)
                    self.user = pointsData
                 }
                 catch let JSONErr{
                     print(JSONErr)
                        }
                    }
                }
            }
        }
    
    extension SettingsViewController: MFMailComposeViewControllerDelegate{
        func sendEmail() {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([self.user.Email])
                mail.setMessageBody("Report", isHTML: true)

                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    
    
