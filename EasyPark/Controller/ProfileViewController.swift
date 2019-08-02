//
//  ProfileViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 30/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {

    let imagepicker = UIImagePickerController()
    var selectedImages: UIImage?
    var uid : String = ""
    var documentid = ""
    var imageName : String = ""
    
    let db = Firestore.firestore()
    var userProfile = [UserProfileModel]()
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        getCurrentUser()
        selectedImage.layer.cornerRadius = 48
        selectedImage.layer.masksToBounds = true
         self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        self.userProfile = []
        self.readData()
    }
    
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {

        do {
            try Auth.auth().signOut()
    
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func EditProfilePressed(_ sender: UIButton) {
 
        let EditProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(EditProfileViewController, animated: true)
    }
    
    //MARK:- Fetch Data from Firebase
    
    func readData() {
        
        let db = Firestore.firestore()
        userProfile = []
        
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let new = UserProfileModel()
                    self.userName.text = "\(document.data()["UserName"] as! String)"
                    new.userName = "\(document.data()["UserName"] as! String)"
                    new.useruid = "\(document.data()["uuid"] as! String)"
                    new.imageName = "\(self.uid)"
                    
                    let storageRef = Storage.storage().reference(withPath: "UserImages/\(document.data()["uuid"] as! String).jpg")
                    
                    storageRef.getData(maxSize: 4*1024*1024) { data, error in
                        if let error = error {
                            print("error downloading image:\(error)")
                        } else {
                            // Data for "images/island.jpg" is returned
                            self.selectedImage.image = UIImage(data: data!)
                            self.userProfile.append(new)
                        }
                    }
                }
            }
        }
    }
}




