//
//  File.swift
//  Habits
//
//  Created by Ahsan Vency on 4/11/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

//Lets us dynamically change all the views that have textfields in them
//The login screens have these views
class textFieldView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red:255/255, green:255/255, blue: 255/255, alpha: 0.55)
        layer.cornerRadius = 20.0
        
    }
}
