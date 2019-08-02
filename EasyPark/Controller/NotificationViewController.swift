//
//  NotificationViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 26/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        enableButton.layer.cornerRadius = 15

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        let LoginSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
        self.navigationController?.pushViewController(LoginSignUpViewController, animated: true)
    }
    
    @IBAction func NotificationButton(_ sender: UIButton) {
        
        let content = UNMutableNotificationContent()
   
        content.title = "Easy Park"
        content.body = "You will be Daily Notified"
        content.sound = UNNotificationSound.default
        content.badge = 1
       
        // MARK:-  Local Notification Triggred Everyday At the same Time
        
        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
          let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
      
        UNUserNotificationCenter.current().add(request){
            (error) in print(error as Any)
        }
    }
    
}
