//
//  ForgotPasswordViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/21/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var newPasswordTxt: UITextField!
    
    @IBOutlet weak var confirmNewPasswordTxt: UITextField!
    @IBOutlet weak var oldPasswordTxt: UITextField!
    var rest = RestManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        if oldPasswordTxt.text != "" && newPasswordTxt.text == confirmNewPasswordTxt.text{
            let defaults = UserDefaults.standard
            let username = defaults.object(forKey: "Username") as! String
            guard let url2 = URL(string: URLStrings.CHANGE_PASSWORD) else { return }
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:username , forKey: "Username")
            rest.httpBodyParameters.add(value:newPasswordTxt.text! , forKey: "Password")
            rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                if let data = results.data {
                 do{
                     let pointsData = try JSONDecoder().decode(RequestResult.self,from:data)
                    let resultString = "Password updated for user '"+username+"'."
                    if pointsData.Result == resultString{
                        DispatchQueue.main.async {
                            let alert2 = UIAlertController(title: "Password Updated.", message: nil, preferredStyle: .alert)
                            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                                alert2!.dismiss(animated: true, completion: nil)
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                            let nav = UINavigationController(rootViewController: viewController)
                            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
                                
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
        else
        {
            let alert2 = UIAlertController(title: "Please fill the details properly", message: nil, preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert2] (_) in
                alert2!.dismiss(animated: true, completion: nil)
            }))
            self.present(alert2, animated: true)
        }
    }
    
    

}
