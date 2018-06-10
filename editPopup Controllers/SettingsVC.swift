//
//  SettingsVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/20/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var userProfileImage: circularImage!
    
    @IBOutlet weak var confirmButton: roundedButton!
    
    var selectedImageFromPicker: UIImage?
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        DataService.ds.REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            
            self.editNameField.text = (value["name"] as! String)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    
    @IBAction func editImage(_ sender: Any) {
        handleProfileImage()
    }
    
    func handleProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"]{
            selectedImageFromPicker = (editedImage as! UIImage)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImageFromPicker = (originalImage as! UIImage)
        }
        
        if let selectedImage = selectedImageFromPicker {
            userProfileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picker")
        dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).jpeg")
        if let uploadData = UIImageJPEGRepresentation(self.userProfileImage.image!, 0.01){
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!);
                    // your uploaded photo url.
                }
            }
        }
    }
    
    
    
    
        
    @IBAction func confirm(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        if editNameField.text != "" {
            
            //current user
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            uploadMedia() { url in
                if url != nil {
                    DataService.ds.REF_USERS.child(uid).updateChildValues(["name" : self.editNameField.text!, "profileImage" : url!])
                }
            }
            
            
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainScreen = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
            view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
            self.present(mainScreen,animated: false, completion: nil)
        }else {
            self.upAlert(messages: "Please fill out all fields")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
}
