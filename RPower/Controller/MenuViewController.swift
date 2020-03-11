//
//  MenuViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/25/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

enum MenuType : Int {
    case home
    case points
    case score
    case friends
    case settings
    case logout
}

class MenuViewController: UITableViewController {

    
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet var menuTableView: UITableView!
    var didTapMenuType:((MenuType) -> Void)?
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.backgroundView = UIImageView(image: UIImage(named: "changePassword.jpg"))
        menuTableView.backgroundView?.alpha = 0.6
        let defaults = UserDefaults.standard
        self.username = defaults.object(forKey: "Username") as! String
        if username != ""
        {
            headerTxt.text = username
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType =  MenuType(rawValue: indexPath.row-1) else {return}
        dismiss(animated: true){
            print("Dismissing \(menuType)")
            self.didTapMenuType?(menuType)
        }
    }
    
    func addSideMenu(){
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {return}
        menuViewController.didTapMenuType = {menuType in
            self.transitionToNewContent(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
       // menuViewController.transitioningDelegate = self
        present(menuViewController, animated:true)
        
    }
    func transitionToNewContent(_ menuType:MenuType){
            let title = String(describing: menuType).capitalized
            self.title = title
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            switch menuType {
            case .points:
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PointsViewController") as! UITabBarController
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
            case .home:
                
               let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
               let nav = UINavigationController(rootViewController: viewController)
               UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
            case .score:
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ScoreBoardViewController") as! ScoreBoardViewController
                let nav = UINavigationController(rootViewController: viewController)
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
            case .friends:
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
                let nav = UINavigationController(rootViewController: viewController)
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
            case .settings:
               let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
               let nav = UINavigationController(rootViewController: viewController)
               UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
            case .logout:
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
            }
        }
    }




