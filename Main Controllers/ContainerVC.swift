//
//  ContainerVC.swift
//  Habits
//
//  Created by Ahsan Vency on 6/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {


    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        sideMenuOpen = false
        sideMenuConstraint.constant = -200
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func toggleSideMenu(){
        if sideMenuOpen{
            sideMenuOpen = false
            sideMenuConstraint.constant = -200
        } else{
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}
