//
//  whereEditPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class whereEditPopupVC: UIViewController {
    @IBOutlet weak var whereText: fancyField!
    var ref: DatabaseReference = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //current user
        guard let user = Auth.auth().currentUser else {
            return
        }
        let uid = user.uid
        ref.child("Habits").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            guard let firstKey = value?.allKeys[0] else {
                print("n")
                return }
            
            
            //using habit key to get dict
            let firstDict = value![firstKey] as! Dictionary<String,Any>
            
            //getting dict values and assigning them to labels
           
            self.whereText.placeholder =  firstDict["Where"] as? String
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        var strToUpdate = whereText.text
        if strToUpdate == "" {
            strToUpdate = whereText.placeholder
        }
        if whereText.text != "" || whereText.placeholder != "" {
            
            
            
            //current user
            guard let user = Auth.auth().currentUser else {
                return
            }
            let uid = user.uid
            
            ref.child("Habits").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                guard let firstKey = value?.allKeys[0] else {
                    print("n")
                    return }
                self.ref.child("Habits").child(uid).child("\(firstKey)").updateChildValues(["Where":strToUpdate])
            }) { (error) in
                print(error.localizedDescription)
            }
            
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let whenView = storyBoard.instantiateViewController(withIdentifier: "MainScreenViewCID") as! MainScreenViewC
                
                self.present(whenView,animated: true, completion: nil)
            
        }
        
        
        
    }
}
