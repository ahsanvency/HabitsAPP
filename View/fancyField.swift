//
//  fancyField.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class fancyField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2).cgColor
        //layer.borderColor = UIColor(red: 0/255, green: 0, blue: 0, alpha: 0.2).cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 5.0;
        layer.masksToBounds = true;
    }

}
