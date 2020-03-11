//
//  Friends.swift
//  RPower
//
//  Created by Rutul Desai on 3/4/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import Foundation

struct Friends : Decodable {
    var Count:Int
    var Friends:[Username]
}

struct Username: Decodable {
    var Username:String?
}
