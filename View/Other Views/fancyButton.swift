//
//  fancyButton.swift
//  Habits
//
//  Created by Ahsan Vency on 3/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class fancyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOpacity = 0.8;
        layer.shadowRadius = 5.0;
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        layer.cornerRadius = 25.0;
        layer.masksToBounds = true;
    }
}
