//
//  Habit.swift
//  Habits
//
//  Created by Ahsan Vency on 1/5/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit

class Habit{
    private var _habitName: String!
    private var _habitPic: UIImage!
    private var _why: String!
    private var _when: String!
    private var _whhere: String!
    
    
    init(habitName: String) {
        _habitName = habitName;
    }
    
    init(habitName: String, habitPic: UIImage) {
        _habitName = habitName;
        _habitPic = habitPic;
    }
    
    init(habitName: String, habitPic: UIImage, why: String, when: String, whhere: String) {
        _habitName = habitName;
        _habitPic = habitPic;
        _why = why;
        _when = when;
        _whhere = whhere;
    }
    
    var habitName: String{
        get{
            return _habitName;
        }
        set{
            _habitName = newValue;
        }
    }
    
    var habitPic: UIImage{
        get{
            return _habitPic;
        }
        set{
            _habitPic = newValue;
        }
    }
    
    var why: String {
        get{
            return _why;
        }
        set{
            _why = newValue;
        }
    }
    
    var when: String{
        get {
            return _when;
        }
        set{
            _when = newValue;
        }
    }
    
    var whhere: String{
        get{
            return _whhere
        }
        set{
            _whhere = newValue;
        }
    }
    
}




