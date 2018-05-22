//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//


//These are the slides we see on the habitInfo screen
//Each time you swipe you will see a slide and they are listed in this folder
//Each slide has its own file because thats how it has to be done
//The remaining slides are similar to this one

import UIKit

class whySlide: UIView {
    
    @IBOutlet weak var intrinsicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var whyField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        whyField.attributedPlaceholder = NSAttributedString(string: "I Want To...",
                                                            attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        whyField.textContentType = UITextContentType("")
    }
    
}
