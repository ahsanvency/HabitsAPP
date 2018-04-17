//
//  ViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 4/16/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        open.target = self.revealViewController()
        open.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
