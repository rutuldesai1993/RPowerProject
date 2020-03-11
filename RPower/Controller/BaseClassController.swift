//
//  BaseClassController.swift
//  RPower
//
//  Created by Rutul Desai on 2/27/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class BaseClassController: UIViewController {

    var transition = SlideInTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    @objc func callMethod() {
       guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {return}
       menuViewController.didTapMenuType = {menuType in
           self.transitionToNewContent(menuType)
       }
       menuViewController.modalPresentationStyle = .overCurrentContext
       menuViewController.transitioningDelegate = self
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

extension BaseClassController : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
