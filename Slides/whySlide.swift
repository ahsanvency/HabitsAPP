//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class whySlide: UIView {
    
    @IBOutlet weak var intrinsicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var whyField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        whyField.isEnabled = true
        
    }
}


