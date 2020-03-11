//
//  ChatMessages.swift
//  RPower
//
//  Created by Rutul Desai on 3/5/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import Foundation

struct ChatMessages : Decodable {
    var Count:Int
    var Messages:[Message]
}

struct Message: Decodable {
    var Sender:String?
    var Reciever:String?
    var DateAndTime:String?
    var Message:String?
}
