//
//  ViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 26/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableButton.layer.cornerRadius = 15
     
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    @IBAction func enableLocation(_ sender: UIButton) {
        
        
        let MapViewController = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
        self.navigationController?.pushViewController(MapViewController, animated: true)
        
    }
    
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        let NotificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(NotificationViewController, animated: true)
        
    }
    
}

