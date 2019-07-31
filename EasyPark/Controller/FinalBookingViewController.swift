//
//  FinalBookingViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 31/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase


class FinalBookingViewController: UIViewController {

    @IBOutlet weak var bookingNumber: UILabel!
    @IBOutlet weak var bookingImage: UIImageView!
    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var bookingLotNumber: UILabel!
    @IBOutlet weak var bookingAlphabet: UILabel!
    @IBOutlet weak var bookingTime: UILabel!
    @IBOutlet weak var bookingLeftTime: UILabel!
    @IBOutlet weak var bookingVehical: UILabel!
    @IBOutlet weak var bookingPlateNumber: UILabel!
    @IBOutlet weak var bookingDriver: UILabel!
    @IBOutlet weak var bookingAmount: UILabel!
    
    var bookNumber : String = ""
    var bookPlace : UIImage?
    var bookPlaceTitle : String = ""
    var bookPlaceNumber : String = ""
    var bookPlaceAlphabetNumber : String = ""
    var bookPlaceTime : String = ""
    var bookPlaceLeftTime : String = ""
    var bookPlaceVehical : String = ""
    var bookPlacePlateNumber : String = ""
    var bookPlaceDriver : String = ""
    var bookPlaceMoney : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingTitle.text = bookPlaceTitle
        bookingImage.image = bookPlace
        bookingAmount.text = bookPlaceMoney
        bookingLotNumber.text = bookPlaceNumber
        bookingAlphabet.text = bookPlaceAlphabetNumber
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BookNowPressed(_ sender: UIButton) {
        
//        let LoginSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
//        self.navigationController?.pushViewController(LoginSignUpViewController, animated: true)
        
        for vc in self.navigationController!.viewControllers {
            if let myViewCont = vc as? UITabBarController
            {
                self.navigationController?.popToViewController(myViewCont, animated: true)
            }
        }
       
    }
}
