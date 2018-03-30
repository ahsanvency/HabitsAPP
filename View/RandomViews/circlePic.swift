//
//  circlePic.swift
//  Habits
//
//  Created by Ahsan Vency on 3/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class circlePic: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = maroonColor.cgColor
    }
}

