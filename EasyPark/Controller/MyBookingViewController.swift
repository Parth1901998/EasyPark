//
//  MyBookingViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 29/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class MyBookingViewController: UIViewController {
    
    var MybookPlace : UIImage?
    var MybookTitle : String = ""
    var MybookNumber : String = ""
    var bookPlaceAlphabetNumber : String = ""
    var bookPlaceTime : String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
             self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
 
}
extension MyBookingViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell") as! MyBookingTableViewCell
        return cell
    }
    
    
}
