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
        layer.borderWidth = 2.0
        layer.borderColor = satinColor.cgColor
        layer.cornerRadius = 5.0;
        layer.masksToBounds = true;
        backgroundColor = seaFoamColor
        textColor = satinColor
    }

}
