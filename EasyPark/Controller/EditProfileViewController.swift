//
//  EditProfileViewController.swift
//  EasyPark
//
//  Created by Parth Bhojak on 31/07/19.
//  Copyright © 2019 Parth Bhojak. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    let imagepicker = UIImagePickerController()
    var selectedImages: UIImage?
    var uid : String = ""
    var documentid = ""
    var imageName : String = ""
    
    let db = Firestore.firestore()
    var userProfile = [UserProfileModel]()
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        selectedImage.layer.cornerRadius = 60
        selectedImage.layer.masksToBounds = true
    }
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
        }
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        imagepicker.allowsEditing = false
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        imagepicker.mediaTypes = ["public.image", "public.movie"]
        present(imagepicker, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        
        var ref: DocumentReference? = nil
        ref = db.collection("Users").addDocument(data:["UserName":"\(userName.text!)","uuid": "\(uid)"])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.documentid = (ref?.documentID)!
                print("Document added with ID: \(ref!.documentID)")
                let uploadRef = Storage.storage().reference(withPath: "UserImages/\(self.uid).jpg")
                
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
}

extension EditProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
