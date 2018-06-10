//
//  newMenuVC.swift
//  Habits
//
//  Created by Ahsan Vency on 6/6/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

//THIS IS NEW CODE

import UIKit
import Firebase
import SwiftKeychainWrapper

class menuVC: UIViewController {

    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var editInfoView: UIView!
    @IBOutlet weak var editRewardsView: UIView!
    
    @IBOutlet weak var profileImage: circularImage!
    @IBOutlet weak var nameOfUser: UILabel!
    
    var user: User?
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up the name on the menu similarly to how the habit info is setup on the main screen
        if let currentUser = user{
            nameOfUser.text = currentUser.name
        }else{
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            DataService.ds.REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! NSDictionary
                
                self.nameOfUser.text = (value["name"] as! String)
                let ref = Storage.storage().reference(forURL: value["profileImage"] as! String)
                
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("JESS: Unable to download image from Firebase storage")
                    } else {
                        print("JESS: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                                menuVC.imageCache.setObject(img, forKey: value["profileImage"] as! NSString)
                            }
                        }
                    }
                })
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        addTouchEvents()
    }
    
    func addTouchEvents(){
        let signOutgesture = UITapGestureRecognizer(target: self, action:  #selector (self.signOutTapped(sender:)))
        self.signOutView.addGestureRecognizer(signOutgesture)
        
        let settingsGesture = UITapGestureRecognizer(target: self, action:  #selector (self.settingsTapped(sender:)))
        self.settingsView.addGestureRecognizer(settingsGesture)
        
        let editInfoGesture = UITapGestureRecognizer(target: self, action:  #selector (self.editInfoTapped(sender:)))
        self.editInfoView.addGestureRecognizer(editInfoGesture)
        
        let editRewardsGesture = UITapGestureRecognizer(target: self, action:  #selector (self.editRewardsTapped(sender:)))
        self.editRewardsView.addGestureRecognizer(editRewardsGesture)
    }
    
    @objc func settingsTapped(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showSettings"), object: nil)
    }
    
    @objc func editInfoTapped(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showEditInfo"), object: nil)
    }
    
    @objc func editRewardsTapped(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showEditRewards"), object: nil)
    }
    
    @objc func signOutTapped(sender: UITapGestureRecognizer){
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
//        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        present(newViewController, animated: false) {}
    }
}
