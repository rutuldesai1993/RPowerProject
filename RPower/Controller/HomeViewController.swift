//
//  HomeViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class HomeViewController: BaseClassController {
    
    var rest = RestManager()
    var user = User()
    var username = ""
    var schoolName = ""
    @IBOutlet weak var dailyPointsTxt: UILabel!
    
    @IBOutlet weak var totalPointsTxt: UILabel!
    @IBOutlet weak var januaryTxt: UILabel!
    @IBOutlet weak var januaryImage: UIImageView!
    
    
    @IBOutlet weak var augTxt: UILabel!
    @IBOutlet weak var augImage: UIImageView!
    @IBOutlet weak var julyTxt: UILabel!
    @IBOutlet weak var julyImage: UIImageView!
    @IBOutlet weak var juneTxt: UILabel!
    @IBOutlet weak var juneImage: UIImageView!
    @IBOutlet weak var mayTxt: UILabel!
    @IBOutlet weak var mayImage: UIImageView!
    
    @IBOutlet weak var decTxt: UILabel!
    @IBOutlet weak var decImage: UIImageView!
    @IBOutlet weak var novTxt: UILabel!
    @IBOutlet weak var novImage: UIImageView!
    @IBOutlet weak var octTxt: UILabel!
    @IBOutlet weak var octImage: UIImageView!
    @IBOutlet weak var septTxt: UILabel!
    @IBOutlet weak var septImage: UIImageView!
    @IBOutlet weak var aprilTxt: UILabel!
    @IBOutlet weak var aprilImage: UIImageView!
    @IBOutlet weak var marchTxt: UILabel!
    @IBOutlet weak var marchImage: UIImageView!
    @IBOutlet weak var febTxt: UILabel!
    @IBOutlet weak var febImage: UIImageView!
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        let defaults = UserDefaults.standard
        self.username = defaults.object(forKey: "Username") as! String
        self.schoolName = defaults.object(forKey: "School") as! String
        guard let url = URL(string: "http://www.consoaring.com/PointService.svc/dailypoints") else { return }
        guard let url2 = URL(string: "http://www.consoaring.com/PointService.svc/totalpoints") else { return }
        guard let url3 = URL(string: "http://www.consoaring.com/PointService.svc/getuserprogress") else { return }
        guard let url4 = URL(string: "http://www.consoaring.com/PointService.svc/totalschoolpoints") else { return }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:self.username , forKey: "Username")
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            if results.response!.httpStatusCode == 200 {
            do{
                let dailypoints = try JSONDecoder().decode(DailyPoints.self, from: results.data!)
                DispatchQueue.main.async {
                self.dailyPointsTxt.text = String(dailypoints.dailypoints)
                }
            }
            catch let JSONErr {
                print(JSONErr)
                }
            }
        }
        rest.makeRequest(toURL: url2, withHttpMethod: .post) { (results) in
            if results.response!.httpStatusCode == 200 {
            do{
                let totalpoints = try JSONDecoder().decode(TotalPoints.self, from: results.data!)
                DispatchQueue.main.async {
                self.totalPointsTxt.text = String(totalpoints.totalpoints)
                }
            }
            catch let JSONErr {
                print(JSONErr)
                }
            }
        }
        rest.makeRequest(toURL: url3, withHttpMethod: .post) { (results) in
            if results.response!.httpStatusCode == 200 {
            do{
                let userprogress = try JSONDecoder().decode(UserProgress.self, from: results.data!)
                DispatchQueue.main.async {
                self.januaryTxt.text = String(userprogress.Jan)+"%"
                self.febTxt.text = String(userprogress.Feb)+"%"
                self.marchTxt.text = String(userprogress.Mar)+"%"
                self.aprilTxt.text = String(userprogress.Apr)+"%"
                self.mayTxt.text = String(userprogress.May)+"%"
                self.juneTxt.text = String(userprogress.Jun)+"%"
                self.julyTxt.text = String(userprogress.Jul)+"%"
                self.augTxt.text = String(userprogress.Aug)+"%"
                self.septTxt.text = String(userprogress.Sep)+"%"
                self.octTxt.text = String(userprogress.Oct)+"%"
                self.novTxt.text = String(userprogress.Nov)+"%"
                self.decTxt.text = String(userprogress.Dec)+"%"
                }
            }
            catch let JSONErr {
                print(JSONErr)
                }
            }
        }
        rest.httpBodyParameters.add(value:schoolName , forKey: "SchoolName")
        rest.makeRequest(toURL: url4, withHttpMethod: .post) { (results) in
            if results.response!.httpStatusCode == 200 {
            do{
                let totalpoints = try JSONDecoder().decode(TotalPoints.self, from: results.data!)
                defaults.set(String(totalpoints.totalpoints), forKey: "SchoolTotalPoints")
            }
            catch let JSONErr {
                print(JSONErr)
                }
            }
        }
    }
        
    }
