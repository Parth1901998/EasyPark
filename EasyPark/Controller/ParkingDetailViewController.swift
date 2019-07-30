//
//  ParkingDetailViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 30/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class ParkingDetailViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var topImage: UIImageView!
    
    @IBOutlet weak var ratingButton: UILabel!
    
    @IBOutlet weak var parksName: UILabel!
    
    @IBOutlet weak var parksTitle: UILabel!

    @IBOutlet weak var cityAddress: UILabel!
    
    @IBOutlet weak var parksDistance: UILabel!
    
    @IBOutlet weak var parksMoney: UILabel!
    
    @IBOutlet weak var parksNumber: UILabel!
    
    @IBOutlet weak var parksAddress: UILabel!
    
    @IBOutlet weak var bookNowPressed: UIButton!
    
    var mallimage : UIImage?
    var userRating : String = ""
    var parkingName : String = ""
    var parkingTitle : String = ""
    var cityVanue : String = ""
    var parkingDistance : String = ""
    var parkingMoney : String = ""
    var parkingNumber : String = ""
    var parkingAddress : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookNowPressed.layer.cornerRadius = 15
        
        topImage.image = mallimage
        ratingButton.text = userRating
        parksName.text = parkingName
        parksTitle.text = parkingTitle
        parksDistance.text = parkingDistance
        parksMoney.text = parkingMoney
        parksNumber.text = parkingNumber
        parksAddress.text = parkingAddress
      
    }
 
    @IBAction func BookNow(_ sender: UIButton) {
        
        let LoginSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
        self.navigationController?.pushViewController(LoginSignUpViewController, animated: true)
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
