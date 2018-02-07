//
//  RandomFunctions.swift
//  Habits
//
//  Created by ahsan vency on 1/2/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit

//Functions
func validateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

let KEY_UID = "uid"

let habitsDict = ["Why": "Click To Edit", "When": "Click To Edit", "Where": "Click To Edit"];

let SHADOW_GRAY: CGFloat = 120.0 / 255.0
