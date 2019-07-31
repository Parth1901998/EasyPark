//
//  MyBookingTableViewCell.swift
//  EasyPark
//
//  Created by Parth Bhojak on 31/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class MyBookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MyBookingImage: UIImageView!
    @IBOutlet weak var MyBookingTitle: UILabel!
    @IBOutlet weak var MyBookingAlphabet: UILabel!
    @IBOutlet weak var MyBookingNumber: UILabel!
    @IBOutlet weak var MyBookingMoney: UILabel!
    @IBOutlet weak var MyBookingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
