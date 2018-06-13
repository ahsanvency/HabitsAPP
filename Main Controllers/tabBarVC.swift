//
//  tabBarVC.swift
//  Habits
//
//  Created by Ahsan Vency on 6/13/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class tabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
//        let mainVCNC = UINavigationController(rootViewController: mainViewController)
//        mainViewController.title = "Home"
//        mainViewController.tabBarItem.image = UIImage(named: "Lifting")
        
        let rewardsViewController = storyBoard.instantiateViewController(withIdentifier: "rewardsVCID") as! rewardsVC
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "menuVCID") as! menuVC
        viewControllers = [mainViewController, rewardsViewController, menuViewController]
    }

}
