//
//  PointsTableViewCell.swift
//  RPower
//
//  Created by Rutul Desai on 3/3/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

protocol AddPointsView {
    func onAddingPoints(index: Int)
    func onAddFavorites(index: Int)
}

class PointsTableViewCell: UITableViewCell {
    @IBAction func addPointsAction(_ sender: UIButton) {
        cellDelegate?.onAddingPoints(index: index!.row)
    }
    var cellDelegate: AddPointsView?
    var index:IndexPath?
    
    @IBOutlet weak var addFavoritesButton: UIButton!
    @IBOutlet weak var addPointsButton: UIButton!
    @IBAction func addFavoriteAction(_ sender: UIButton) {
        cellDelegate?.onAddFavorites(index: index!.row)
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
