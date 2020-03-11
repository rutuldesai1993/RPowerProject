//
//  FriendRequestTableViewCell.swift
//  RPower
//
//  Created by Rutul Desai on 3/4/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

protocol AddFriendsView {
    func onAcceptingRequest(index: Int)
    func onRejectingRequest(index: Int)
}

class FriendRequestTableViewCell: UITableViewCell {

    @IBAction func rejectAction(_ sender: UIButton) {
        cellDelegate?.onRejectingRequest(index: index!.row)
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        cellDelegate?.onAcceptingRequest(index: index!.row)
    }
    @IBOutlet weak var usernameLbl: UILabel!
    var cellDelegate: AddFriendsView?
    var index:IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
