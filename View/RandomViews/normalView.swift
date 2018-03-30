//
//  normalField.swift
//  Habits
//
//  Created by Ahsan Vency on 2/18/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class normalView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = maroonColor.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0;
        layer.masksToBounds = true;
        backgroundColor = UIColor.white
    }
    
}
