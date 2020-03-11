//
//  ViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/21/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let rest = RestManager()
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginButtonPressed: UIButton!
    @IBAction func clearButtonPressed(_ sender: Any) {
        userNameTxt.text = ""
        passwordTxt.text = ""
    }
    @IBOutlet weak var keepMeLoggedInSwitch: UISwitch!
    @IBOutlet weak var passwordTxt: UITextField!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter your Email Address", message: nil, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text ?? "")")
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
       
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let optionMenu = UIAlertController(title: "RPower", message: "Choose Option", preferredStyle: .actionSheet)
            
        // 2
        let deleteAction = UIAlertAction(title: "Haverford", style: .default, handler: {
            (UIAlertAction) in
            self.defaults.set("Haverford", forKey: "School")
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
        })
        let saveAction = UIAlertAction(title: "Agnes Irwin", style: .default, handler: {
            (UIAlertAction) in
            self.defaults.set("Agnes Irwin", forKey: "School")
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
        })
            
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
          
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if(userNameTxt.text == "" || passwordTxt.text == "")
        {
            let optionMenu = UIAlertController(title: "Login Failed", message: "Please fill in all the details", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (UIAlertAction) in
             self.dismiss(animated: true, completion: nil)
            })
             optionMenu.addAction(cancelAction)
             present(optionMenu, animated: true, completion: nil)
        }
        else{
            guard let url = URL(string: URLStrings.USER_AUTHENTICATION) else { return }
            guard let url2 = URL(string: URLStrings.GET_CURRENT_USER) else { return }
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:userNameTxt.text! , forKey: "Username")
            rest.httpBodyParameters.add(value: passwordTxt.text!, forKey: "Password")
            rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
                //guard let response = results.response else { return }
                 if results.response!.httpStatusCode == 200 {
                    DispatchQueue.main.async {
                        self.defaults.set(self.userNameTxt.text, forKey: "Username")
                     
                     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                     let nav = UINavigationController(rootViewController: viewController)
                     UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
                    }
                }
            }
            rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
                //guard let response = results.response else { return }
                 if results.response!.httpStatusCode == 200 {
                    do{
                        let user = try JSONDecoder().decode(User.self, from: results.data!)
                        self.defaults.set(user.SchoolName, forKey: "School")
                   }
                    catch let JSONErr {
                        print(JSONErr)
                        }
                    }
                }
            }
            
            
        }
        
    }


