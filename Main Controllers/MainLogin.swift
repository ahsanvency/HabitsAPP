//
//  ViewController.swift
//  Habits
//
//  Created by ahsan vency on 1/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MainLogin: UIViewController {

    var success: Int?
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var sloganLbl: UILabel!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var newUserLbl: UILabel!
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    //If the user already logged in it will take them to the main screen with swift keychainwrapper
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScreen(){
//        titleView.backgroundColor = blueColor
//        screenTitle.textColor = satinColor
//        sloganLbl.textColor = satinColor
//        loginLbl.textColor = satinColor
//        newUserLbl.textColor = satinColor
    }
}

