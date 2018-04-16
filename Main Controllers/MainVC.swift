//
//  MainVC.swift
//  Habits
//
//  Created by Ahsan Vency on 4/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewGradientVertical(view: headerView)
        
    }
    
}
