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
   
    var posts = [TotalParkingModel]()
    let db = Firestore.firestore()
    
    var uid : String = ""
    var documentid = ""

      let activityIndicator = UIActivityIndicatorView()
    
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
        getCurrentUser()
    }
    
    func getCurrentUser(){
        if let user = Auth.auth().currentUser?.uid{
            uid = user
        }
        print("uid" , uid)
    }
    @IBAction func onBackPressed(_ sender: UIButton) {
        activityIndicator.stopAnimating()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func BookNowPressed(_ sender: UIButton) {
        
//        let LoginSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
//        self.navigationController?.pushViewController(LoginSignUpViewController, animated: true)
    
        let alert = UIAlertController(title: "Are you Sure?", message: "You are going to book Parking.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            self.activityIndicator.stopAnimating()
        }))
        alert.addAction(UIAlertAction(title: "Are you Sure?",style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
                                        for vc in self.navigationController!.viewControllers {
                                            if let myViewCont = vc as? UITabBarController
                                            {
                                                self.navigationController?.popToViewController(myViewCont, animated: true)
                                            }
                                        }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        //MARK:- Activity Indicator Fucction
        
        func loadingIndicator()
        {
            
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            activityIndicator.center = self.view.center
            activityIndicator.assignColor(.black)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
        
        //MARK:- UPLOAD BOOK NOW DATA TO FIREBASE
        
            var ref: DocumentReference? = nil
                ref = db.collection("Booking").addDocument(data:["title":"\(bookingTitle.text!)","number":"\(bookingLotNumber.text!)","alphabet":"\(bookingAlphabet.text!)","uuid": "\(uid)"])
            {
                err in
                
                loadingIndicator()
                
                if let err = err {
                print("Error adding document: \(err)")
                    } else {
                    
                    self.documentid = (ref?.documentID)!
                
                let uploadRef = Storage.storage().reference(withPath: "Images/\(self.uid).jpg")
                guard let imagedata = self.bookingImage.image!.jpegData(compressionQuality: 0.75) else{return}
                let uploadMetadata = StorageMetadata.init()
                print(uploadRef)
                uploadMetadata.contentType = "image/jpeg"
                    uploadRef.putData(imagedata, metadata: uploadMetadata) { (downloadMetadata, error) in
                        if let error = error
                            {
                            print("oh no got an error \(error.localizedDescription)")
                            return
                            }
                        print("put is complete and i got it back:\(String(describing: downloadMetadata))")
            
                        }
                    }
                }
        
            bookingTitle.text = " "
        }
    
    }

