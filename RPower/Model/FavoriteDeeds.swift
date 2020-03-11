//
//  FavoriteDeeds.swift
//  RPower
//
//  Created by Rutul Desai on 3/4/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import Foundation

struct FavoriteDeeds : Decodable {
    var Count:Int
    var TasksList:[Task]
    var Username:String?
}

struct Task: Decodable {
    var Task:String?
}
