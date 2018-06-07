//
//  SettingsVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/20/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController{

    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var userProfileImage: circularImage!
    
    @IBOutlet weak var confirmButton: roundedButton!
    
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
//        handleProfileImage()
    }
    
    
    @IBAction func confirm(_ sender: Any) {

        
        dismiss(animated: true, completion: nil)
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(userProfileImage.image!){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteURL{
                    
                }
            }
        }
        
        
        if editNameField.text != "" {
            
            //current user
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            DataService.ds.REF_USERS.child(uid).updateChildValues(["name" : editNameField.text!])
            
            
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
