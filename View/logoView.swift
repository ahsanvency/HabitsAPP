//
//  logoView.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class logoView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8.0;
        layer.masksToBounds = true;
    }

}
