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
    

    var MybookPlace : UIImageView?
    var MybookTitle : String = ""
    var MybookNumber : String = ""
    var bookPlaceAlphabetNumbers : String = ""
    var bookPlaceTime : String = ""
    
    let db = Firestore.firestore()
      var parkingDetail = [TotalParkingModel]()
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
             self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func readData()
    {
        db.collection("Booking").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    // most Important
                    let malldetail = TotalParkingModel()
                    malldetail.placeTitle = (document.data()["title"] as! String)
            
                    malldetail.placeNumber = (document.data()["number"] as! String)
                    
                    malldetail.placeLotAlphabet = (document.data()["alphabet"] as! String)
            
                    
                    // feching data
                    
                    let storeRef = Storage.storage().reference(withPath: "Images/\(malldetail.placeTitle).jpg")//document.documentID
                    
                    storeRef.getData(maxSize: 4 * 1024 * 1024, completion: {(data, error) in
                        if let error = error {
                            print("error-------- \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            print("Main data\(data)")
                            malldetail.placeImage  = UIImage(data: data)!
                            self.tableView.reloadData()
                            
                        }
                    })
                    //self.nows.append(nownewitem.image!)
                    self.parkingDetail.append(malldetail)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    
    }
}

extension MyBookingViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableViewCell") as! MyBookingTableViewCell
        cell.MyBookingTitle.text = parkingDetail[indexPath.row].placeTitle
        cell.MyBookingNumber.text = parkingDetail[indexPath.row].placeNumber
        cell.MyBookingAlphabet.text = parkingDetail[indexPath.row].placeLotAlphabet
        cell.MyBookingImage.image = parkingDetail[indexPath.row].placeImage
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
