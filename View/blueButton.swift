//
//  blueButtons.swift
//  Habits
//
//  Created by Ahsan Vency on 2/18/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class blueButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(UIImage(named: "BackBlue.png"), for: .normal)
    }
    
}
