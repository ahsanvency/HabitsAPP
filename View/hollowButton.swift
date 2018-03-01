//
//  hollowButton.swift
//  Habits
//
//  Created by Ahsan Vency on 2/28/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class hollowButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor;
        layer.borderColor = satinColor.cgColor
        layer.borderWidth = 2.0
        layer.shadowOpacity = 0.8;
        layer.shadowRadius = 5.0;
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        layer.cornerRadius = 20.0;
        layer.masksToBounds = true;
        backgroundColor = seaFoamColor
        setTitleColor(satinColor, for: .normal)
    }
}
