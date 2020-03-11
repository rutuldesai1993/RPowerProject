//
//  User.swift
//  RPower
//
//  Created by Rutul Desai on 3/2/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import Foundation

class User: Decodable {
    var Username:String = ""
    var Password:String? = ""
    var Email:String = ""
    var TouchIdOn:Bool = false
    var Avatarimageurl:String = ""
    var SchoolName:String = ""
}
