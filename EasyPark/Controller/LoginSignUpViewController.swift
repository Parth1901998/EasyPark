//
//  LoginSignUpViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 29/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class LoginSignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.setNavigationBarHidden(true, animated: true)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            
            let myBookingVc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
            self.navigationController?.pushViewController(myBookingVc, animated: true)
        }
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVc, animated: true)

    }
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        
        let signupVc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVc, animated: true)
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
