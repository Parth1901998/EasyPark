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
    
    
    let db = Firestore.firestore()
    var uid : String = ""
    var documentid = ""
    var imageName : String = ""
    
    var userProfile = [UserProfileModel]()
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getCurrentUser()
        selectedImage.layer.cornerRadius = 60
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
        
    }
    

    @IBAction func selectImage(_ sender: UIButton) {
        
        imagepicker.allowsEditing = false
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        imagepicker.mediaTypes = ["public.image", "public.movie"]
        present(imagepicker, animated: true, completion: nil)
    }
   
    
    
    @IBAction func UpdatePressed(_ sender: UIButton) {
        
        var ref: DocumentReference? = nil
        ref = db.collection("Users").addDocument(data:["UserName":"\(userName.text!)","uuid": "\(uid)"])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.documentid = (ref?.documentID)!
                print("Document added with ID: \(ref!.documentID)")
                let uploadRef = Storage.storage().reference(withPath: "UserImages/\(self.documentid).jpg")
                
                guard let imagedata = self.selectedImage.image?.jpegData(compressionQuality: 0.75) else{return}
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
        userName.text = " "
    }
    
    func readData() {
        
        let db = Firestore.firestore()
        userProfile = []
        
        db.collection("UserName").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let new = UserProfileModel()
                    new.userName = "\(document.data()["UserName"] as! String)"
                    new.useruid = "\(document.data()["uuid"] as! String)"
                    new.imageName = "\(document.documentID)"
                    
                    let storageRef = Storage.storage().reference(withPath: "UserImages/\(document.documentID).jpg")
                    storageRef.getData(maxSize: 4*1024*1024) { data, error in
                        if let error = error {
                            print("error downloading image:\(error)")
                        } else {
                            // Data for "images/island.jpg" is returned
                            new.userimage = UIImage(data: data!)
                            self.userProfile.append(new)
                            
                        }
                    }
                }
            }
        }
    }

}

extension ProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        if let editedImage = info[.editedImage] as? UIImage {
            
            selectedImages = editedImage
            
            selectedImage.image = selectedImages!
            
            picker.dismiss(animated: true, completion: nil)
            
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            
            selectedImages = originalImage
            
            selectedImage.image = selectedImages!
            
        }
        
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        
        imageName = fileUrl.lastPathComponent
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
}


