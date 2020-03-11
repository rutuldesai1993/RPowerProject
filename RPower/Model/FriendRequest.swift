//
//  FriendRequest.swift
//  RPower
//
//  Created by Rutul Desai on 3/4/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import Foundation

struct FriendRequest: Decodable {
    var Count:Int
    var Requests:[Username]?
}
