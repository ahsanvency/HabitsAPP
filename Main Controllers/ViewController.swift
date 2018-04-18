//
//  ViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 4/16/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        self.present(newViewController, animated: false, completion: nil)
    }
    
}
