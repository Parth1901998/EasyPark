//
//  TableViewCell.swift
//  EasyPark
//
//  Created by Parth Bhojak on 29/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell: UITableViewCell {

    @IBOutlet weak var parkTitle: UILabel!
    
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var ParkRating: UILabel!
    
    @IBOutlet weak var parkDistance: UILabel!
    
    @IBOutlet weak var parkLot: UILabel!
    
    @IBOutlet weak var parkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  

}
