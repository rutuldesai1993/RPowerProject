//
//  ScoreBoardViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/24/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class ScoreBoardViewController: BaseClassController {
    
    @IBOutlet weak var haverfordScore: UILabel!
    
    @IBOutlet weak var agnesIrwinScore: UILabel!
    var rest = RestManager()
    let defaults = UserDefaults.standard
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Score Board"
        guard let url = URL(string: URLStrings.TOTAL_SCHOOL_POINTS) else { return }
            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        let schoolName = defaults.object(forKey: "School") as! String
        let schoolTotalPoints = defaults.object(forKey: "SchoolTotalPoints") as! String
        if(schoolName == "Agnes Irwin")
        {
           rest.httpBodyParameters.add(value:"Haverford" , forKey: "SchoolName")
            rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
                if results.response!.httpStatusCode == 200 {
                do{
                    let haverfordpoints = try JSONDecoder().decode(TotalPoints.self, from: results.data!)
                    print(String(haverfordpoints.totalpoints))
                    DispatchQueue.main.async {
                    self.haverfordScore.text = String(haverfordpoints.totalpoints)
                    self.agnesIrwinScore.text = schoolTotalPoints
                    }
                }
                catch let JSONErr {
                    print(JSONErr)
                    }
                }
            }
        }
        else
        {
           rest.httpBodyParameters.add(value:"Agnes Irwin" , forKey: "SchoolName")
            rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
                if results.response!.httpStatusCode == 200 {
                do{
                    let haverfordpoints = try JSONDecoder().decode(TotalPoints.self, from: results.data!)
                    print(String(haverfordpoints.totalpoints))
                    DispatchQueue.main.async {
                    self.agnesIrwinScore.text = String(haverfordpoints.totalpoints)
                    self.haverfordScore.text = schoolTotalPoints                    }
                }
                catch let JSONErr {
                    print(JSONErr)
                    }
                }
            }
        }
    }
    
   
    
}
