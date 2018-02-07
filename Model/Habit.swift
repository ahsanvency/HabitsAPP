//
//  Habit.swift
//  Habits
//
//  Created by Ahsan Vency on 1/5/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation

class Habit{
    private var _name: String!
    private var _why: String!
    private var _when: String!
    private var _whhere: String!
    
    init(name: String, why: String, when: String, whhere: String) {
        _name = name;
        _why = why;
        _when = when;
        _whhere = whhere;
    }
    
    var name: String{
        get{
            return _name;
        }
        set{
            _name = newValue;
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




