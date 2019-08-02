//
//  SignUpViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 29/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var signupPressed: UIButton!
    
      let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupPressed.layer.cornerRadius = 15
    }
    
    func Indicator()
    {
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.assignColor(.black)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }

    @IBAction func signUpAction(_ sender: UIButton) {
         Indicator()
        if password.text != confirmPassword.text
        {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
            if error == nil {
                let HomeVc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                self.navigationController?.pushViewController(HomeVc, animated: true)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    activityIndicator.stopAnimating()
}
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        activityIndicator.stopAnimating()
    }
    
}
