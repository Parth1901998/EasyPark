//
//  NotificationViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 26/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    

    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        enableButton.layer.cornerRadius = 15
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        let LoginSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
        self.navigationController?.pushViewController(LoginSignUpViewController, animated: true)
    }
    
}
