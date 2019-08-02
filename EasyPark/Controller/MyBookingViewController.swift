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
    var bookPlaceAlphabetNumbers : String = ""
    var bookPlaceTime : String = ""
    var uid : String = ""
    var documentid = ""
    
    let db = Firestore.firestore()
    var parkingDetail = [TotalParkingModel]()
    
    let activityIndicator = UIActivityIndicatorView()
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        getCurrentUser()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        Indicator()
        self.readData()

    }
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
        }
    }
    
    //MARK:- Loading Indicator
    
    func Indicator()
    {
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.assignColor(.black)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    //MARK:- Fetch Booking DATA FROM FIREBASE
    
    func readData()
    {
        Indicator()
         parkingDetail = []
        
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
                    
                    malldetail.useruid = (document.data()["uuid"] as! String)
            
                    // feching data
                    
                  //  let storeRef = Storage.storage().reference(withPath: "Images/\(document.data()["uuid"] as! String).jpg")
                      let storeRef = Storage.storage().reference(withPath: "Images/\(document.data()["uuid"] as! String).jpg")
                    
                    storeRef.getData(maxSize: 4 * 1024 * 1024, completion: {(data, error) in
                        if let error = error {
                            print("error-------- \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
    
                            malldetail.placeImage  = UIImage(data: data)!
                            self.parkingDetail.append(malldetail)
                            self.tableView.reloadData()
                            
                        }
                    })

                }
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
}

extension MyBookingViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingDetail.count
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
        return 170
    }
}
